package network;

import com.exadel.flamingo.flex.messaging.amf.io.AMF3Serializer;
import org.apache.log4j.Logger;
import org.jboss.netty.buffer.ChannelBuffer;
import org.jboss.netty.buffer.ChannelBufferOutputStream;
import org.jboss.netty.buffer.ChannelBuffers;
import org.jboss.netty.channel.Channel;
import org.jboss.netty.channel.ChannelHandlerContext;
import org.jboss.netty.handler.codec.oneone.OneToOneEncoder;

/**
 * Author: JuzTosS
 * Date: 11.06.12
 */
public class PacketFrameEncoder extends OneToOneEncoder
{
    private final Logger logger = Logger.getLogger(PacketFrameEncoder.class);

    @Override
    protected Object encode(ChannelHandlerContext channelhandlercontext, Channel channel, Object obj) throws Exception
    {
        Response response = (Response) obj;
        ChannelBuffer b = ChannelBuffers.dynamicBuffer();
        AMF3Serializer to = new AMF3Serializer(new ChannelBufferOutputStream(b));
        Object[] serializable = {response.response_id, response.params};
        to.writeObject(serializable);
        to.close();
        return b;
    }
}