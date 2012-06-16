package objects;

import crypt.Crypter;
import db.DataBase;
import network.CMDList;
import network.Command;
import org.apache.log4j.Logger;
import org.jboss.netty.channel.Channel;
import org.jboss.netty.channel.ChannelHandler;

/**
 * Author: JuzTosS
 * Date: 12.06.12
 */

public class UserWorker extends Thread
{
    private final Logger logger = Logger.getLogger(UserWorker.class);

    private UserState user_state;

    private ChannelHandler _handler;
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
        log_cmd(cmd);

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
            case CMDList.CREATE_OBJECT_ON_FIELD:
                create_object(cmd);
                break;
            default:
                logger.error("Unknown command type");
        }
    }

    private void log_cmd(Command cmd)
    {
        String command_params_to_trace = "";
        for(int i = 0; i < cmd.params.length; i++){
            command_params_to_trace += ", " + cmd.params[i];
        }
        logger.info(":: accept command : " + cmd.command_id + command_params_to_trace);
    }

    private void create_object(Command cmd)
    {

    }

    private void load_user(Command cmd)
    {
        Object[] cmd_params = cmd.params;

        user_state = (UserState) DataBase.ds().find(UserState.class, "login", cmd_params[0]).get();
        logger.info(user_state.login);
        logger.info(user_state.password);
    }

    private void create_user(Command cmd)
    {
        Object[] cmd_params = cmd.params;

        user_state = new UserState();
        user_state.login = (String) cmd_params[0];
        user_state.password = Crypter.encrypt((String) cmd_params[1]);

        DataBase.ds().save(user_state);
    }


}
