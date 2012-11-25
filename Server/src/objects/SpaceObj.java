package objects;

import com.google.code.morphia.annotations.Embedded;
import com.google.code.morphia.annotations.Entity;
import com.google.code.morphia.annotations.Id;
import org.bson.types.ObjectId;

import java.util.HashMap;

/**
 * Author: JuzTosS
 * Date: 17.06.12
 */
@Entity
public class SpaceObj
{
    @Id
    ObjectId eDatabaseId;

    @Embedded
    int x;
    @Embedded
    int y;

    @Embedded
    String classId = "0";


    public HashMap<String, Object> getSerialized()
    {
        HashMap<String, Object> sObj = new HashMap<String, Object>();
        sObj.put("classId", classId);
        sObj.put("x", ((Integer) x).toString());
        sObj.put("y", ((Integer) x).toString());

        return sObj;
    }
}
