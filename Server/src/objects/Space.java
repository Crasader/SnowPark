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
    ObjectId eDatabaseId;

    @Embedded
    ArrayList<SpaceObj> objects = new ArrayList<SpaceObj>();

}
