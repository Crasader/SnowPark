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

    private UserWorker userWorker;

    @Override
    public void channelConnected(ChannelHandlerContext ctx, ChannelStateEvent e) throws Exception
    {
        userWorker = new UserWorker(this, e.getChannel());
    }

    @Override
    public void channelDisconnected(ChannelHandlerContext ctx, ChannelStateEvent e) throws Exception
    {
        userWorker.disconnectedFromChannel();
    }

    @Override
    public void messageReceived(ChannelHandlerContext ctx, MessageEvent e)
    {
        if (e.getChannel().isOpen())
            userWorker.acceptCommand((Command) e.getMessage());
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, ExceptionEvent e)
    {
        logger.error(e.getCause().getMessage());
        ctx.getChannel().close();
    }
}