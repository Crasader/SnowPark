package network;

import org.jboss.netty.channel.ChannelPipeline;
import org.jboss.netty.channel.ChannelPipelineFactory;
import org.jboss.netty.channel.Channels;

/**
 * Author: JuzTosS
 * Date: 11.06.12
 */
public class ServerPipelineFactory implements ChannelPipelineFactory
{
    @Override
    public ChannelPipeline getPipeline() throws Exception
    {
        PacketFrameDecoder decoder = new PacketFrameDecoder();
        PacketFrameEncoder encoder = new PacketFrameEncoder();
        UserHandler player_handler = new UserHandler();
        AuthenticationHandler authentication_handler = new AuthenticationHandler();

        return Channels.pipeline(decoder, encoder, authentication_handler, player_handler);
    }
}