package objects;

import config.ConfigReader;
import db.DataBase;
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

    public UserWorker()
    {
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


    public void createNew(String userId)
    {
        _userState = new UserState();
        _userState.spaces = getNewUserSpaces();
        _userState.heightMap = getNewUserHeightMap();
        _userState.id = userId;

        DataBase.ds().save(_userState);
    }

    public void load(UserState userState)
    {
        _userState = userState;
    }

    private void logCmd(HashMap<String, Object> data)
    {
        logger.info(":: accept command : " + data.toString());
    }

    public HashMap<String, Object> processCommand(HashMap<String, Object> data) throws Exception
    {

        logCmd(data);

        String cmd = (String) data.get("cmd");
        HashMap<String, Object> params = (HashMap<String, Object>) data.get("params");
        if (cmd.contentEquals("getUserData"))
            return processGetUserData(params);
        else if (cmd.contentEquals("create"))
            return processCreate(params);
        else if (cmd.contentEquals("changeHeight"))
            return processChangeHeight(params);
        else if (cmd.contentEquals("destroy"))
            return processDestroy(params);
        else
        {
            HashMap<String, Object> unknownCmd = new HashMap<String, Object>();
            unknownCmd.put("Warning", "Unknown command: " + cmd);
            return unknownCmd;
        }
    }

    private HashMap<String, Object> processDestroy(HashMap<String, Object> params) throws Exception
    {
        Integer spaceId = (Integer) params.get("spaceId");
        Space sp = _userState.spaces.get(spaceId);
        if (sp == null)
        {
            throw new Exception("Invalid spaceId: " + params.toString());
        }

        Iterator<SpaceObj> it = sp.objects.iterator();
        while (it.hasNext())
        {
            SpaceObj obj = it.next();
            if (obj.classId.contentEquals((String) params.get("classId"))
                    && obj.x == (Integer) params.get("x")
                    && obj.y == (Integer) params.get("y"))
            {
                break;
            }
        }

        it.remove();
        DataBase.ds().save(_userState);//TODO: update

        return new HashMap<String, Object>();
    }

    private HashMap<String, Object> processChangeHeight(HashMap<String, Object> params) throws Exception
    {
        Integer x = (Integer) params.get("x");
        Integer y = (Integer) params.get("y");
        Integer newHeight = (Integer) params.get("height");

        for (int i = 0; i < 2; i++)
            for (int j = 0; j < 2; j++)
            {
                int neighborHeight = _userState.heightMap.get(x).get(y);
                if ((neighborHeight - newHeight) > 1)
                    throw new Exception("Invalid height: " + newHeight.toString() + " x: " + x.toString() + " y:" + y.toString());
            }

        _userState.heightMap.get(x).set(y, newHeight);

        DataBase.ds().save(_userState);//TODO: update
        return new HashMap<String, Object>();
    }

    private HashMap<String, Object> processCreate(HashMap<String, Object> params)
    {
        Integer spaceId = (Integer) params.get("spaceId");
        Space sp = _userState.spaces.get(spaceId);
        if (sp == null)
        {
            sp = new Space();
            _userState.spaces.put(spaceId, sp);
        }

        SpaceObj obj = new SpaceObj();
        obj.classId = (String) params.get("classId");
        obj.x = (Integer) params.get("x");
        obj.y = (Integer) params.get("y");

        String advanced = (String) params.get("advanced");
        if (advanced != null) obj.advanced = advanced;

        sp.objects.add(obj);

        DataBase.ds().save(_userState);//TODO: update

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
