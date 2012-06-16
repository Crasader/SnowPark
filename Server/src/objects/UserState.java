package objects;

import com.google.code.morphia.annotations.Embedded;
import com.google.code.morphia.annotations.Entity;
import com.google.code.morphia.annotations.Id;
import org.bson.types.ObjectId;

/**
 * Author: JuzTosS
 * Date: 16.06.12
 */
@Entity("game_users")
public class UserState
{
    @Id
    ObjectId e_database_id;

    @Embedded
    public String password;
    @Embedded
    public String login;

    @Embedded
    public Space field;
}
