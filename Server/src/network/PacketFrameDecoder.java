package network;

import com.exadel.flamingo.flex.messaging.amf.io.AMF3Deserializer;
import com.sun.org.apache.bcel.internal.util.ByteSequence;
import org.apache.log4j.Logger;
import org.jboss.netty.buffer.ChannelBuffer;
import org.jboss.netty.channel.Channel;
import org.jboss.netty.channel.ChannelHandlerContext;
import org.jboss.netty.channel.ChannelStateEvent;
import org.jboss.netty.handler.codec.replay.ReplayingDecoder;
import org.jboss.netty.handler.codec.replay.VoidEnum;

/**
 * Author: JuzTosS
 * Date: 11.06.12
 */
public class PacketFrameDecoder extends ReplayingDecoder<VoidEnum>
{

    private final Logger logger = Logger.getLogger(PacketFrameDecoder.class);

    @Override
    public void channelClosed(ChannelHandlerContext ctx, ChannelStateEvent e) throws Exception
    {
        ctx.sendUpstream(e);
    }

    @Override
    public void channelDisconnected(ChannelHandlerContext ctx, ChannelStateEvent e) throws Exception
    {
        ctx.sendUpstream(e);
    }

    @Override
    protected Object decode(ChannelHandlerContext arg0, Channel arg1, ChannelBuffer buffer, VoidEnum e) throws Exception
    {
        ChannelBuffer cb = buffer.readBytes(buffer.writerIndex());
        AMF3Deserializer d = new AMF3Deserializer(new ByteSequence(cb.array()));
        Object[] o = (Object[]) d.readObject();
        Command command = new Command();
        command.commandId = (Integer) o[0];
        command.params = (Object[]) o[1];
        return command;
    }
}

