package network;

import objects.UserWorker;
import org.apache.log4j.Logger;
import org.jboss.netty.channel.*;

import java.util.ArrayList;
import java.util.Iterator;

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
        {
            ArrayList<Command> cmdSeq = (ArrayList<Command>) e.getMessage();
            Iterator<Command> itCmd = cmdSeq.iterator();
            while (itCmd.hasNext())
            {
                userWorker.acceptCommand(itCmd.next());
            }
        }
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, ExceptionEvent e)
    {
        logger.error(e.getCause().getMessage());
        ctx.getChannel().close();
    }
}