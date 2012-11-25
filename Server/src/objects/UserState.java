package objects;

import com.google.code.morphia.annotations.Embedded;
import com.google.code.morphia.annotations.Entity;
import com.google.code.morphia.annotations.Id;
import org.bson.types.ObjectId;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * Author: JuzTosS
 * Date: 16.06.12
 */
@Entity("game_users")
public class UserState
{
    @Id
    ObjectId eDatabaseId;

    @Embedded
    public String id = "";

    @Embedded
    public HashMap<Integer, Space> spaces = new HashMap<Integer, Space>();

    @Embedded
    public ArrayList<ArrayList<Integer>> heightMap = new ArrayList<ArrayList<Integer>>();
}
