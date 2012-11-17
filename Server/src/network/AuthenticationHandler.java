package network;

import db.DataBase;
import errors.Errors;
import network.spec.AUTH;
import network.spec.CREATEUSER;
import objects.UserState;
import org.apache.log4j.Logger;
import org.jboss.netty.channel.*;
import utils.CryptUtil;

import java.util.ArrayList;
import java.util.Iterator;

/**
 * Created with IntelliJ IDEA.
 * UserDBO: JuzTosS
 * Date: 23.04.12
 * Time: 21:29
 */
public class AuthenticationHandler extends SimpleChannelHandler
{

    private static final Logger logger = Logger.getLogger(AuthenticationHandler.class);

    private static final int AUTH_PASSED = 1;
    private static final int AUTH_FAILED = 0;

    @Override
    public void messageReceived(ChannelHandlerContext ctx, MessageEvent e) throws Exception
    {
        Response response = new Response();
        response.responseId = AUTH.ID;

        if (processCmd(e))
        {
            logger.info(":: auth passed");
            response.params = new Object[]{AUTH_PASSED};
            e.getChannel().write(response);
            super.messageReceived(ctx, e);
            ctx.getPipeline().remove(this);
        } else
        {
            logger.info(":: auth failed");
            response.params = new Object[]{AUTH_FAILED};
            e.getChannel().write(response);
        }
    }

    private boolean processCmd(MessageEvent e)
    {
        try
        {
            ArrayList<Command> cmdSeq = (ArrayList<Command>) e.getMessage();
            Iterator<Command> itCmd = cmdSeq.iterator();
            while (itCmd.hasNext())
            {
                Command cmd = itCmd.next();
                switch (cmd.commandId)
                {
                    case AUTH.ID:
                        return auth(cmd);
                    case CREATEUSER.ID:
                        return true;
                    default:
                        logger.info("Wrong auth command = " + cmd.commandId);
                        return false;
                }
            }
            return false;

        } catch (Exception exc)
        {
            Errors.logError(logger, exc);
            return false;
        }
    }

    private boolean auth(Command cmd)
    {
        String login = (String) cmd.params[AUTH.LOGIN];
        String pass = (String) cmd.params[AUTH.PASSWORD];

        UserState us = DataBase.ds().find(UserState.class, "login", login).get();

        if (us == null) return false;

        String hashedPass = CryptUtil.hashPass(pass, us.salt);
        if (us.password.contentEquals(hashedPass))
            return true;
        else
            return false;
    }

    @Override
    public void channelClosed(ChannelHandlerContext ctx, ChannelStateEvent e) throws Exception
    {

        // Здесь, при закрытии подключения, прописываем закрытие всех связанных ресурсов для корректного завершения.
    }


    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, ExceptionEvent e) throws Exception
    {
        Errors.logError(logger, e);
    }
}
