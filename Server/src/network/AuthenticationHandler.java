package network;

import org.apache.log4j.Logger;
import org.jboss.netty.channel.*;

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
        response.response_id = CMDList.AUTH;

        if (process_cmd(e))
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

    private boolean process_cmd(MessageEvent e)
    {
        try
        {
            Command cmd = (Command) e.getMessage();

            switch (cmd.command_id)
            {
                case CMDList.AUTH:
                    return auth(cmd);
                case CMDList.CREATE_USER:
                    return true;
                default:
                    throw new Exception("Wrong first command = " + cmd.command_id);
            }

        } catch (Exception exc)
        {
            logger.error(exc.getCause().getMessage());
            return false;
        }
    }

    private boolean auth(Command cmd)
    {
        if (cmd.params[0].toString().contentEquals("JuzTosS"))
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
        logger.error(e.getCause().getMessage());
    }
}
