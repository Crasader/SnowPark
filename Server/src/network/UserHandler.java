package network;

import objects.UserWorker;
import org.apache.log4j.Logger;
import org.jboss.netty.channel.*;

/**
 * Author: JuzTosS
 * Date: 11.06.12
 */
public class UserHandler extends SimpleChannelUpstreamHandler
{
    private final Logger logger = Logger.getLogger(UserHandler.class);

    private UserWorker user_worker;

    @Override
    public void channelConnected(ChannelHandlerContext ctx, ChannelStateEvent e) throws Exception
    {
        logger.info("channelConnected");
        user_worker = new UserWorker(this, e.getChannel());
    }

    @Override
    public void channelDisconnected(ChannelHandlerContext ctx, ChannelStateEvent e) throws Exception
    {
        user_worker.disconnectedFromChannel();
    }

    @Override
    public void messageReceived(ChannelHandlerContext ctx, MessageEvent e)
    {
        logger.info("messageReceived");
        if (e.getChannel().isOpen())
            user_worker.acceptCommand((Command) e.getMessage());
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, ExceptionEvent e)
    {
        logger.error(e.getCause().getMessage());
        ctx.getChannel().close();
    }
}