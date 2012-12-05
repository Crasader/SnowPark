package objects;

import db.DataBase;
import org.apache.log4j.Logger;

import java.util.HashMap;

/**
 * Author: JuzTosS
 * Date: 25.11.12
 */
public class UsersCache
{
    //TODO: Удалять пользователей из памяти через некоторое время неактивности
    private final Logger logger = Logger.getLogger(UserWorker.class);

    private HashMap<String, UserWorker> _usersHash = new HashMap<String, UserWorker>();

    public UserWorker getUser(String id)
    {
        UserWorker user = _usersHash.get(id);
        if (user != null)
            return user;

        user = new UserWorker();
        UserState userState = DataBase.ds().find(UserState.class, "id", id).get();
        if (userState == null)
            user.createNew(id);
        else
            user.load(userState);

        _usersHash.put(id, user);

        return user;
    }

}
