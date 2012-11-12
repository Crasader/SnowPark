package objects;

import config.CFG;
import db.DataBase;
import errors.Errors;
import network.CMDList;
import network.Command;
import network.Response;
import org.apache.log4j.Logger;
import org.jboss.netty.channel.Channel;
import org.jboss.netty.channel.ChannelHandler;
import org.yaml.snakeyaml.Yaml;
import utils.CryptUtil;
import utils.Util;

import java.util.*;

/**
 * Author: JuzTosS
 * Date: 12.06.12
 */

public class UserWorker extends Thread
{
    private final Logger logger = Logger.getLogger(UserWorker.class);

    private UserState _userState;

    private ChannelHandler _handler;
    private Channel _channel;

    private Boolean _stopped = false;

    volatile private LinkedList<Command> _commandQueue = new LinkedList<Command>();

    public UserWorker(ChannelHandler handler, Channel channel)
    {
        _handler = handler;
        _channel = channel;
    }

    public void disconnectedFromChannel()
    {
        _stopped = true;
    }

    private void sendErrorResponce(int cmdId)
    {
        Response resp = new Response();
        resp.responseId = cmdId;
        resp.params = new Object[]{Errors.ERROR};
        _channel.write(resp);
    }

    @Override
    public void run()
    {
        while (!_stopped)
        {
            if (_commandQueue.size() > 0)
            {
                Command cmd = _commandQueue.removeFirst();
                processCommand(cmd);
            }
        }
    }

    private void processCommand(Command cmd)
    {

        if (cmd == null) return;

        logCmd(cmd);

        try
        {
            switch (cmd.commandId)
            {
                case CMDList.CREATE_USER:
                    createUser(cmd);
                    break;
                case CMDList.AUTH:
                    loadUser(cmd);
                    break;
                case CMDList.GET_USER_STATE:
                    returnUserState(cmd);
                    break;
                case CMDList.CREATE_OBJECT_ON_FIELD:
                    createObject(cmd);
                    break;
                default:
                    logger.error("Unknown command type");
            }
        } catch (Exception exc)
        {
            sendErrorResponce(cmd.commandId);
            Errors.logError(logger, exc);
        }
    }

    private void returnUserState(Command cmd)
    {
        Object[] cmdParams = cmd.params;

        Space field = _userState.spaces.get(SpacesList.FIELD);

        Response resp = new Response();
        resp.responseId = cmd.commandId;
        Collection<SpaceObj> objects = field.objects.values();
        Iterator<SpaceObj> objIt = objects.iterator();

        ArrayList<Object[]> serializedObjs = new ArrayList<Object[]>();
        while (objIt.hasNext())
            serializedObjs.add(objIt.next().getSerialized());
        resp.params = new Object[]{serializedObjs.toArray()};
        _channel.write(resp);

        logger.info("return field for user: " + _userState.login);
    }

    public void acceptCommand(Command cmd)
    {
        _commandQueue.push(cmd);

        if (!isAlive())
            start();
    }

    private void logCmd(Command cmd)
    {
        String commandParamsToTrace = "";
        for (int i = 0; i < cmd.params.length; i++)
        {
            commandParamsToTrace += ", " + cmd.params[i];
        }
        logger.info(":: accept command : " + cmd.commandId + commandParamsToTrace);
    }

    private void createObject(Command cmd) throws Exception
    {
        Object[] cmdParams = cmd.params;
        int objectId = (Integer) cmdParams[0];
        int classId = (Integer) cmdParams[1];
        int group = (Integer) cmdParams[2];
        int x = (Integer) cmdParams[3];
        int y = (Integer) cmdParams[4];
        int width = (Integer) cmdParams[5];
        int height = (Integer) cmdParams[6];

        Space sp = _userState.spaces.get(group);
        if (sp == null)
        {
            sp = new Space();
            _userState.spaces.put(group, sp);
        }

        SpaceObj obj = sp.objects.get(objectId);
        if (obj != null) throw new Exception("Object already created!");

        obj = new SpaceObj();
        obj.objectId = objectId;
        obj.classId = classId;
        obj.x = x;
        obj.y = y;
        obj.width = width;
        obj.height = height;

        sp.objects.put(objectId, obj);

        DataBase.ds().save(_userState);//TODO: update
    }

    private void loadUser(Command cmd)
    {
        Object[] cmdParams = cmd.params;

        _userState = DataBase.ds().find(UserState.class, "login", cmdParams[0]).get();
        logger.info("load user state for user: " + _userState.login);
    }

    private void createUser(Command cmd) throws Exception
    {
        Object[] cmdParams = cmd.params;

        _userState = new UserState();
        _userState.login = (String) cmdParams[0];
        _userState.salt = CryptUtil.getSalt(4);
        System.out.println(cmdParams[1].toString());
        _userState.password = CryptUtil.hashPass(cmdParams[1].toString(), _userState.salt);

        _userState.spaces = getNewUserConfig();
        DataBase.ds().save(_userState);
    }

    private HashMap<Integer, Space> getNewUserConfig()
    {
        Yaml yaml = new Yaml();
        String configString = Util.getLocalResource(CFG.LOCATION_CONFIG_NAME);
        Map<String, ArrayList<HashMap<String, String>>> configObj = (Map<String, ArrayList<HashMap<String, String>>>) yaml.load(configString);
        ArrayList<HashMap<String, String>> startLocation = configObj.get("playerStartLocation");

        for (int i = 0; i < startLocation.size(); i++)
        {
            HashMap<String, String> fieldObjectConfig = startLocation.get(i);
            System.out.println(fieldObjectConfig);

            createDefinedObject(fieldObjectConfig);
        }


        HashMap<Integer, Space> userConfig = new HashMap<Integer, Space>();
        return userConfig;
    }

    private SpaceObj createDefinedObject(HashMap<String, String> fieldObjectConfig)
    {
        SpaceObj object = new SpaceObj();

        Set<String> params = fieldObjectConfig.keySet();
        Iterator<String> paramsIt = params.iterator();
        while (paramsIt.hasNext())
        {
            String key = paramsIt.next();
            if (key == "id")
            {
                object.classId = Integer.getInteger(fieldObjectConfig.get("id"));
            } else if (key == "x")
            {
                object.x = Integer.getInteger(fieldObjectConfig.get("x"));
            } else if (key == "y")
            {
                object.x = Integer.getInteger(fieldObjectConfig.get("y"));
            }

        }
        return object;
    }


}
