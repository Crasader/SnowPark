package objects;

import config.ConfigReader;
import db.DataBase;
import network.Command;
import org.apache.log4j.Logger;

import java.util.*;

/**
 * Author: JuzTosS
 * Date: 12.06.12
 */

public class UserWorker extends Thread
{
    private final Logger logger = Logger.getLogger(UserWorker.class);

    private UserState _userState;

    private Boolean _stopped = false;

    volatile private LinkedList<Command> _commandQueue = new LinkedList<Command>();

    public UserWorker()
    {
    }

//    private void changeHeight(Command cmd)
//    {
//        Object[] cmdParams = cmd.params;
//        _userState.heightMap.get((Integer) cmdParams[CHANGEHEIGHT.X]).set((Integer) cmdParams[CHANGEHEIGHT.Y], (Integer) cmdParams[CHANGEHEIGHT.H]);
//
//        DataBase.ds().save(_userState);//TODO: update
//    }

//    private void returnUserState(Command cmd)
//    {
//        Object[] cmdParams = cmd.params;
//
//        Response resp = new Response();
//        resp.responseId = cmd.commandId;
//
//        Space field = _userState.spaces.get(SpacesList.MAIN_FIELD);
//        Collection<SpaceObj> objects = field.objects;
//        Iterator<SpaceObj> objIt = objects.iterator();
//
//        ArrayList<Object[]> serializedObjs = new ArrayList<Object[]>();
//        while (objIt.hasNext())
//            serializedObjs.add(objIt.next().getSerialized());
//
//        ArrayList<Object[]> serializedHeightMap = new ArrayList<Object[]>();
//        Iterator<ArrayList<Integer>> heightIt = _userState.heightMap.iterator();
//        while (heightIt.hasNext())
//            serializedHeightMap.add(heightIt.next().toArray());
//
//        ArrayList<Object> params = new ArrayList<Object>(2);
//        params.add(GETUSERSTATE.FIELD_OBJS, serializedObjs.toArray());
//        params.add(GETUSERSTATE.HEIGHT_MAP, serializedHeightMap.toArray());
//        resp.params = params.toArray();
//
//        _channel.write(resp);
//
//        logger.info("return field for user: " + _userState.login);
//    }

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

//    private void createObject(Command cmd) throws Exception
//    {
//        Object[] cmdParams = cmd.params;
//        String classId = (String) cmdParams[CREATEOBJECT.CLASS_ID];
//        int space = (Integer) cmdParams[CREATEOBJECT.SPACE_ID];
//        int x = (Integer) cmdParams[CREATEOBJECT.X];
//        int y = (Integer) cmdParams[CREATEOBJECT.Y];
//
//        Space sp = _userState.spaces.get(space);
//        if (sp == null)
//        {
//            sp = new Space();
//            _userState.spaces.put(space, sp);
//        }
//
//        SpaceObj obj = new SpaceObj();
//        obj.classId = classId;
//        obj.x = x;
//        obj.y = y;
//
//        sp.objects.add(obj);
//
//        DataBase.ds().save(_userState);//TODO: update
//    }

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


    public void createNew()
    {
        _userState = new UserState();
        _userState.spaces = getNewUserSpaces();
        _userState.heightMap = getNewUserHeightMap();

        DataBase.ds().save(_userState);
    }

    public void load(UserState userState)
    {
        _userState = userState;
    }

    public HashMap<String, Object> processCommand(HashMap<String, Object> data)
    {

        String cmd = (String) data.get("cmd");
        HashMap<String, Object> params = (HashMap<String, Object>) data.get("params");
        if (cmd.contentEquals("getUserData"))
            return processGetUserData(params);
        else if (cmd.contentEquals("create"))
            return processCreate(params);
        else if (cmd.contentEquals("changeHeight"))
            return processChangeHeight(params);
        else
        {
            HashMap<String, Object> unknownCmd = new HashMap<String, Object>();
            unknownCmd.put("Warning", "Unknown command: " + cmd);
            return unknownCmd;
        }
    }

    private HashMap<String, Object> processChangeHeight(HashMap<String, Object> params)
    {
        return new HashMap<String, Object>();
    }

    private HashMap<String, Object> processCreate(HashMap<String, Object> params)
    {
        return new HashMap<String, Object>();
    }

    private HashMap<String, Object> processGetUserData(HashMap<String, Object> data)
    {
        String type = (String) data.get("type");

        if (type != null && type.contentEquals("all"))
        {
            Space field = _userState.spaces.get(SpacesList.MAIN_FIELD);
            Collection<SpaceObj> objects = field.objects;
            Iterator<SpaceObj> objIt = objects.iterator();

            ArrayList<Object> serializedObjs = new ArrayList<Object>();
            while (objIt.hasNext())
                serializedObjs.add(objIt.next().getSerialized());

            ArrayList<Object[]> serializedHeightMap = new ArrayList<Object[]>();
            Iterator<ArrayList<Integer>> heightIt = _userState.heightMap.iterator();
            while (heightIt.hasNext())
                serializedHeightMap.add(heightIt.next().toArray());

            HashMap<String, Object> resp = new HashMap<String, Object>();
            resp.put("objects", serializedObjs.toArray());
            resp.put("heightMap", serializedHeightMap.toArray());
            resp.put("type", "all");
            return resp;
        }

        return new HashMap<String, Object>();
    }
}
