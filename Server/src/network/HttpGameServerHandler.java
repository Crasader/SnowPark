package network;

import org.jboss.netty.buffer.ChannelBuffers;
import org.jboss.netty.channel.ChannelFutureListener;
import org.jboss.netty.channel.ChannelHandlerContext;
import org.jboss.netty.channel.MessageEvent;
import org.jboss.netty.handler.codec.http.DefaultHttpResponse;
import org.jboss.netty.handler.codec.http.HttpResponse;
import org.jboss.netty.handler.codec.http.HttpResponseStatus;
import org.jboss.netty.util.CharsetUtil;

import static org.jboss.netty.handler.codec.http.HttpHeaders.Names.CONTENT_TYPE;
import static org.jboss.netty.handler.codec.http.HttpVersion.HTTP_1_1;

/**
 * Author: JuzTosS
 * Date: 19.11.12
 */
public class HttpGameServerHandler extends HttpStaticFileServerHandler
{
    @Override
    public void messageReceived(ChannelHandlerContext ctx, MessageEvent e) throws Exception
    {
        System.out.println("message recived");
        sendOKStatus(ctx);
    }

    public void sendOKStatus(ChannelHandlerContext ctx)
    {
        HttpResponse response = new DefaultHttpResponse(HTTP_1_1, HttpResponseStatus.OK);
        response.setHeader(CONTENT_TYPE, "text/plain; charset=UTF-8");
        response.setContent(ChannelBuffers.copiedBuffer(
                "OK",
                CharsetUtil.UTF_8));

        ctx.getChannel().write(response).addListener(ChannelFutureListener.CLOSE);
    }

}
