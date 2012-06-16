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
    int group;

    @Embedded
    int id;

}
