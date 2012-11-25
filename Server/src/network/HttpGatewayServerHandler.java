package network;

import org.apache.log4j.Logger;
import org.jboss.netty.buffer.ChannelBuffer;
import org.jboss.netty.buffer.ChannelBuffers;
import org.jboss.netty.channel.*;
import org.jboss.netty.handler.codec.frame.TooLongFrameException;
import org.jboss.netty.handler.codec.http.DefaultHttpResponse;
import org.jboss.netty.handler.codec.http.HttpRequest;
import org.jboss.netty.handler.codec.http.HttpResponse;
import org.jboss.netty.handler.codec.http.HttpResponseStatus;
import org.jboss.netty.util.CharsetUtil;

import static org.jboss.netty.handler.codec.http.HttpHeaders.Names.CONTENT_TYPE;
import static org.jboss.netty.handler.codec.http.HttpMethod.POST;
import static org.jboss.netty.handler.codec.http.HttpResponseStatus.*;
import static org.jboss.netty.handler.codec.http.HttpVersion.HTTP_1_1;

/**
 * Author: JuzTosS
 * Date: 19.11.12
 */

public class HttpGatewayServerHandler extends SimpleChannelUpstreamHandler
{
    private static final Logger logger = Logger.getLogger(HttpGatewayServerHandler.class);

    public static final String NEWLINE = "\r\n";

    @Override
    public void messageReceived(ChannelHandlerContext ctx, MessageEvent e) throws Exception
    {
        HttpRequest request = (HttpRequest) e.getMessage();

        if (request.getUri().contains("/crossdomain.xml"))
        {
            sendCrossdomain(ctx, e);
            return;
        }

        if (request.getUri().contains("/crossdomain.xml"))
        {
            sendCrossdomain(ctx, e);
            return;
        }

        if (request.getMethod() == POST)
        {
            ctx.sendUpstream(e);
            return;
        }

        sendServerIsRunning(ctx);
    }

    private void sendServerIsRunning(ChannelHandlerContext ctx)
    {
        HttpResponse response = new DefaultHttpResponse(HTTP_1_1, OK);
        response.setHeader(CONTENT_TYPE, "text/plain; charset=UTF-8");
        response.setContent(ChannelBuffers.copiedBuffer(
                "Server status: ON",
                CharsetUtil.UTF_8));

        ctx.getChannel().write(response).addListener(ChannelFutureListener.CLOSE);
    }

    private void sendCrossdomain(ChannelHandlerContext ctx, MessageEvent e) throws Exception
    {
        Object msg = e.getMessage();
        ChannelFuture f = e.getChannel().write(getPolicyFileContents());
        f.addListener(ChannelFutureListener.CLOSE);
    }

    private ChannelBuffer getPolicyFileContents() throws Exception
    {


        return ChannelBuffers.copiedBuffer(
                "<?xml version=\"1.0\"?>" + NEWLINE +
                        "<!DOCTYPE cross-domain-policy SYSTEM \"/xml/dtds/cross-domain-policy.dtd\">" + NEWLINE +
                        "<cross-domain-policy> " + NEWLINE +
                        "   <site-control permitted-cross-domain-policies=\"master-only\"/>" + NEWLINE +
                        "   <allow-access-from domain=\"*\" to-ports=\"80\" />" + NEWLINE +
                        "</cross-domain-policy>" + NEWLINE,
                CharsetUtil.UTF_8);
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, ExceptionEvent e)
            throws Exception
    {
        logger.error(e.getCause().getMessage());

        Channel ch = e.getChannel();
        Throwable cause = e.getCause();
        if (cause instanceof TooLongFrameException)
        {
            sendHTTPError(ctx, BAD_REQUEST);
            return;
        }

        cause.printStackTrace();
        if (ch.isConnected())
        {
            sendHTTPError(ctx, INTERNAL_SERVER_ERROR);
        }
    }

    protected static void sendHTTPError(ChannelHandlerContext ctx, HttpResponseStatus status)
    {
        HttpResponse response = new DefaultHttpResponse(HTTP_1_1, status);
        response.setHeader(CONTENT_TYPE, "text/plain; charset=UTF-8");
        response.setContent(ChannelBuffers.copiedBuffer(
                "Failure: " + status.toString() + NEWLINE,
                CharsetUtil.UTF_8));

        ctx.getChannel().write(response).addListener(ChannelFutureListener.CLOSE);
    }

}