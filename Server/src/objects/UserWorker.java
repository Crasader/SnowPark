package objects;

import errors.Errors;
import db.DataBase;
import helpers.CryptHelper;
import network.CMDList;
import network.Command;
import network.Response;
import org.apache.log4j.Logger;
import org.jboss.netty.channel.Channel;
import org.jboss.netty.channel.ChannelHandler;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.LinkedList;

/**
 * Author: JuzTosS
 * Date: 12.06.12
 */

public class UserWorker extends Thread
{
    private final Logger logger = Logger.getLogger(UserWorker.class);

    private UserState _user_state;

    private ChannelHandler _handler;
    private Channel _channel;

    private Boolean _stopped = false;

    volatile private LinkedList<Command> _command_queue = new LinkedList<Command>();

    public UserWorker(ChannelHandler handler, Channel channel)
    {
        _handler = handler;
        _channel = channel;
    }

    public void disconnectedFromChannel()
    {
        _stopped = true;
    }

    private void send_bad_responce(int cmd_id)
    {
        Response resp = new Response();
        resp.response_id = cmd_id;
        resp.params = new Object[]{Errors.ERROR};
        _channel.write(resp);
    }

    @Override
    public void run()
    {
        while (!_stopped)
        {
            if (_command_queue.size() > 0)
            {
                Command cmd = _command_queue.removeFirst();
                process_command(cmd);
            }
        }
    }

    private void process_command(Command cmd)
    {

        if (cmd == null) return;

        log_cmd(cmd);

        try
        {
            switch (cmd.command_id)
            {
                case CMDList.CREATE_USER:
                    create_user(cmd);
                    break;
                case CMDList.AUTH:
                    load_user(cmd);
                    break;
                case CMDList.GET_USER_STATE:
                    return_user_state(cmd);
                    break;
                case CMDList.CREATE_OBJECT_ON_FIELD:
                    create_object(cmd);
                    break;
                default:
                    logger.error("Unknown command type");
            }
        } catch (Exception exc)
        {
            send_bad_responce(cmd.command_id);
            Errors.log_error(logger, exc);
        }
    }

    private void return_user_state(Command cmd)
    {
        Object[] cmd_params = cmd.params;

        Space field = _user_state.spaces.get(SpacesList.FIELD);

        Response resp = new Response();
        resp.response_id = cmd.command_id;
        Collection<SpaceObj> objects = field.objects.values();
        Iterator<SpaceObj> obj_it = objects.iterator();

        ArrayList<Object[]> serialized_objs = new ArrayList<Object[]>();
        while (obj_it.hasNext())
            serialized_objs.add(obj_it.next().getSerialized());
        resp.params = new Object[]{serialized_objs.toArray()};
        _channel.write(resp);

        logger.info("return field for user: " + _user_state.login);
    }

    public void acceptCommand(Command cmd)
    {
        _command_queue.push(cmd);

        if (!isAlive())
            start();
    }

    private void log_cmd(Command cmd)
    {
        String command_params_to_trace = "";
        for (int i = 0; i < cmd.params.length; i++)
        {
            command_params_to_trace += ", " + cmd.params[i];
        }
        logger.info(":: accept command : " + cmd.command_id + command_params_to_trace);
    }

    private void create_object(Command cmd) throws Exception
    {
        Object[] cmd_params = cmd.params;
        int object_id = (Integer) cmd_params[0];
        int class_id = (Integer) cmd_params[1];
        int group = (Integer) cmd_params[2];
        int x = (Integer) cmd_params[3];
        int y = (Integer) cmd_params[4];
        int width = (Integer) cmd_params[5];
        int height = (Integer) cmd_params[6];

        Space sp = _user_state.spaces.get(group);
        if(sp == null){
            sp = new Space();
            _user_state.spaces.put(group, sp);
        }

        SpaceObj obj =  sp.objects.get(object_id);
        if(obj != null) throw new Exception("Object already created!");

        obj = new SpaceObj();
        obj.object_id = object_id;
        obj.class_id = class_id;
        obj.x = x;
        obj.y = y;
        obj.width = width;
        obj.height = height;

        sp.objects.put(object_id, obj);

        DataBase.ds().save(_user_state);//TODO: update
    }

    private void load_user(Command cmd)
    {
        Object[] cmd_params = cmd.params;

        _user_state = DataBase.ds().find(UserState.class, "login", cmd_params[0]).get();
        logger.info("load user state for user: " + _user_state.login);
    }

    private void create_user(Command cmd) throws Exception
    {
        Object[] cmd_params = cmd.params;

        _user_state = new UserState();
        _user_state.login = (String) cmd_params[0];
        _user_state.salt = CryptHelper.getSalt(4);
        System.out.println(cmd_params[1].toString());
        _user_state.password = CryptHelper.hashPass(cmd_params[1].toString(), _user_state.salt);
        DataBase.ds().save(_user_state);
    }


}
