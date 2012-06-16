package objects;

import com.google.code.morphia.annotations.Embedded;
import com.google.code.morphia.annotations.Entity;
import com.google.code.morphia.annotations.Id;
import org.bson.types.ObjectId;

import java.util.ArrayList;

/**
 * Author: JuzTosS
 * Date: 17.06.12
 */
@Entity("Spaces")
public class Space
{
    @Id
    ObjectId e_database_id;

    @Embedded
    String name;

    @Embedded
    ArrayList<SpaceObj> objects;

}
