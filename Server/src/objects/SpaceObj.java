package objects;

import com.google.code.morphia.annotations.Embedded;
import com.google.code.morphia.annotations.Entity;
import com.google.code.morphia.annotations.Id;
import org.bson.types.ObjectId;

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


    public Object[] getSerialized()
    {
        return new Object[]{classId, x, y};
    }
}
