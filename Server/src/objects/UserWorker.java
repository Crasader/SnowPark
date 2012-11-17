package objects;

import config.ConfigReader;
import config.Constants;
import db.DataBase;
import errors.Errors;
import network.Command;
import network.Response;
import network.spec.*;
import org.apache.log4j.Logger;
import org.jboss.netty.channel.Channel;
import org.jboss.netty.channel.ChannelHandler;
import utils.CryptUtil;

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
                case CREATEUSER.ID:
                    createUser(cmd);
                    break;
                case AUTH.ID:
                    loadUser(cmd);
                    break;
                case GETUSERSTATE.ID:
                    returnUserState(cmd);
                    break;
                case CREATEOBJECT.ID:
                    createObject(cmd);
                    break;
                case CHANGEHEIGHT.ID:
                    changeHeight(cmd);
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

    private void changeHeight(Command cmd)
    {
        Object[] cmdParams = cmd.params;
        _userState.heightMap.get((Integer) cmdParams[CHANGEHEIGHT.X]).set((Integer) cmdParams[CHANGEHEIGHT.Y], (Integer) cmdParams[CHANGEHEIGHT.H]);

        DataBase.ds().save(_userState);//TODO: update
    }

    private void returnUserState(Command cmd)
    {
        Object[] cmdParams = cmd.params;

        Response resp = new Response();
        resp.responseId = cmd.commandId;

        Space field = _userState.spaces.get(SpacesList.MAIN_FIELD);
        Collection<SpaceObj> objects = field.objects;
        Iterator<SpaceObj> objIt = objects.iterator();

        ArrayList<Object[]> serializedObjs = new ArrayList<Object[]>();
        while (objIt.hasNext())
            serializedObjs.add(objIt.next().getSerialized());

        ArrayList<Object[]> serializedHeightMap = new ArrayList<Object[]>();
        Iterator<ArrayList<Integer>> heightIt = _userState.heightMap.iterator();
        while (heightIt.hasNext())
            serializedHeightMap.add(heightIt.next().toArray());

        ArrayList<Object> params = new ArrayList<Object>();
        params.set(GETUSERSTATE.FIELD_OBJS, serializedObjs.toArray());
        params.set(GETUSERSTATE.HEIGHT_MAP, serializedHeightMap.toArray());
        resp.params = params.toArray();

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
        String classId = (String) cmdParams[CREATEOBJECT.CLASS_ID];
        int space = (Integer) cmdParams[CREATEOBJECT.SPACE_ID];
        int x = (Integer) cmdParams[CREATEOBJECT.X];
        int y = (Integer) cmdParams[CREATEOBJECT.Y];

        Space sp = _userState.spaces.get(space);
        if (sp == null)
        {
            sp = new Space();
            _userState.spaces.put(space, sp);
        }

        SpaceObj obj = new SpaceObj();
        obj.classId = classId;
        obj.x = x;
        obj.y = y;

        sp.objects.add(obj);

        DataBase.ds().save(_userState);//TODO: update
    }

    private void loadUser(Command cmd)
    {
        Object[] cmdParams = cmd.params;

        _userState = DataBase.ds().find(UserState.class, "login", cmdParams[AUTH.LOGIN]).get();
        logger.info("load user state for user: " + _userState.login);
    }

    private void createUser(Command cmd) throws Exception
    {
        Object[] cmdParams = cmd.params;

        _userState = new UserState();
        _userState.login = (String) cmdParams[CREATEUSER.LOGIN];
        _userState.salt = CryptUtil.getSalt(Constants.SALT_LENGTH);
        _userState.password = CryptUtil.hashPass(cmdParams[CREATEUSER.PASSWORD].toString(), _userState.salt);

        _userState.spaces = getNewUserSpaces();
        _userState.heightMap = getNewUserHeightMap();

        DataBase.ds().save(_userState);
    }

    private ArrayList<ArrayList<Integer>> getNewUserHeightMap()
    {
        return (ArrayList<ArrayList<Integer>>) ConfigReader.cfg().get("startLocationHeightMap");
    }

    private HashMap<Integer, Space> getNewUserSpaces()
    {
        ArrayList<HashMap<String, String>> startLocation = (ArrayList<HashMap<String, String>>) ConfigReader.cfg().get("playerStartLocation");

        Space field = new Space();
        for (int i = 0; i < startLocation.size(); i++)
        {
            HashMap<String, String> fieldObjectConfig = startLocation.get(i);

            SpaceObj obj = createDefinedObject(fieldObjectConfig);
            field.objects.add(obj);
        }

        HashMap<Integer, Space> userConfig = new HashMap<Integer, Space>();
        userConfig.put(SpacesList.MAIN_FIELD, field);

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
                object.classId = fieldObjectConfig.get("id");
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
