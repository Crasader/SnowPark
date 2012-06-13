package objects;

import com.google.code.morphia.annotations.Embedded;
import com.google.code.morphia.annotations.Entity;
import com.google.code.morphia.annotations.Id;
import com.google.code.morphia.annotations.Transient;
import db.DataBase;
import network.CMDList;
import network.Command;
import org.apache.log4j.Logger;
import org.bson.types.ObjectId;
import org.jboss.netty.channel.Channel;
import org.jboss.netty.channel.ChannelHandler;

/**
 * Author: JuzTosS
 * Date: 12.06.12
 */
@Entity
public class UserWorker extends Thread
{
    @Transient
    private final Logger logger = Logger.getLogger(UserWorker.class);

    @Id
    ObjectId e_database_id;
    @Embedded
    String e_password;
    @Embedded
    String e_login;

    @Transient
    private ChannelHandler _handler;
    @Transient
    private Channel _channel;

    public UserWorker(ChannelHandler handler, Channel channel)
    {
        _handler = handler;
        _channel = channel;
    }

    public void disconnectedFromChannel()
    {

    }

    public void acceptCommand(Command cmd)
    {
        logger.info(":: accept command : " + cmd.command_id + " : " + cmd.params.toString());
        switch (cmd.command_id)
        {
            case CMDList.CREATE_USER:
                create_user(cmd);
                break;
            case CMDList.AUTH:
                load_user(cmd);
                break;
            case CMDList.GET_USER_STATE:

                break;
            default:
                logger.error("Unknown command type");
        }
    }

    private void load_user(Command cmd)
    {

    }

    private void create_user(Command cmd)
    {
        Object[] cmd_params = cmd.params;
        e_login = (String) cmd_params[0];
        e_password = (String) cmd_params[1];

        logger.info(e_login);
        logger.info(e_password);

        DataBase.inst().get_ds().save(this);
    }


}
