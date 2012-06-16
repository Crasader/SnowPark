package db;


import com.google.code.morphia.Datastore;
import com.google.code.morphia.Morphia;
import com.mongodb.Mongo;
import config.CFG;

import java.net.UnknownHostException;

public class DataBase
{
    public static final String USERS_COLLECTION = "game_users";

    private static DataBase _instance;
    private static final String DB_NAME = CFG.APP_NAME + "_DB";


    public static DataBase inst()
    {
        if (_instance == null)
        {
            _instance = new DataBase();
        }
        return _instance;
    }

    private static Datastore ds;

    private DataBase()
    {
    }

    public void init() throws UnknownHostException
    {
        Morphia morphia = new Morphia();
        Mongo mongo = new Mongo(/*CFG.DATABASE_HOST, CFG.DATABASE_PORT*/);
        ds = morphia.createDatastore(mongo, DB_NAME);
        morphia.mapPackage("objects", true);
    }

    public static Datastore ds()
    {
        return ds;
    }
}
