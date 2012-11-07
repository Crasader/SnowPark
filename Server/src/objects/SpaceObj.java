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
    ObjectId e_database_id;

    @Embedded
    int x;
    @Embedded
    int y;

    @Embedded
    int object_id;

    @Embedded
    int class_id;

    @Embedded
    int width;

    @Embedded
    int height;

    public Object[] getSerialized()
    {
        return new Object[]{object_id, class_id, x, y, width, height};
    }
}