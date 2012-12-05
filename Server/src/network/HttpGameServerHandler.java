package network;

import com.mongodb.util.JSON;
import objects.UserWorker;
import objects.UsersCache;
import org.apache.log4j.Logger;
import org.jboss.netty.buffer.ChannelBuffer;
import org.jboss.netty.buffer.ChannelBuffers;
import org.jboss.netty.channel.ChannelFutureListener;
import org.jboss.netty.channel.ChannelHandlerContext;
import org.jboss.netty.channel.ExceptionEvent;
import org.jboss.netty.channel.MessageEvent;
import org.jboss.netty.handler.codec.http.*;
import org.jboss.netty.util.CharsetUtil;

import java.net.URLDecoder;
import java.util.*;

import static org.jboss.netty.handler.codec.http.HttpHeaders.Names.CONTENT_TYPE;
import static org.jboss.netty.handler.codec.http.HttpVersion.HTTP_1_1;

/**
 * Author: JuzTosS
 * Date: 19.11.12
 */
public class HttpGameServerHandler extends HttpGatewayServerHandler
{
    private static final Logger logger = Logger.getLogger(HttpGameServerHandler.class);

    private static final String VK_CALLBACK = "/vk_callback";

    private UsersCache usersCache = new UsersCache();

    @Override
    public void messageReceived(ChannelHandlerContext ctx, MessageEvent e) throws Exception
    {

        HttpRequest request = (HttpRequest) e.getMessage();

        String uri = request.getUri();
        if (uri.contentEquals(VK_CALLBACK))
            processVKCallback(ctx, request.getContent());
        else
            processCommand(ctx, decodePost(request));

    }

    private void processVKCallback(ChannelHandlerContext ctx, ChannelBuffer cb)
    {
        System.out.println("processVKCallback");
        QueryStringDecoder decoder = new QueryStringDecoder("?" +
                cb.toString(CharsetUtil.UTF_8));

        Map<String, List<String>> params = decoder.getParameters();

        HttpResponse response = new DefaultHttpResponse(HTTP_1_1, HttpResponseStatus.OK);
        response.setHeader(CONTENT_TYPE, "text/plain; charset=UTF-8");
        response.setContent(ChannelBuffers.copiedBuffer(
                "{\"response\":{\"order_id\":" + params.get("order_id").get(0).toString() + "}}",
                CharsetUtil.UTF_8));

        ctx.getChannel().write(response).addListener(ChannelFutureListener.CLOSE);
    }

    private HashMap<String, Object> decodePost(HttpRequest request) throws Exception
    {
        String contentStr = request.getContent().toString(CharsetUtil.UTF_8);
        String decodedContentStr = URLDecoder.decode(contentStr, "UTF-8");
        decodedContentStr = decodedContentStr.substring(5); //Вырезаем "data=" в начале строки, парсер не обрабатывает
        HashMap<String, Object> content = (HashMap<String, Object>) JSON.parse(decodedContentStr);
        return content;
    }

    private void processCommand(ChannelHandlerContext ctx, HashMap<String, Object> data) throws Exception
    {
        try
        {
            UserWorker user = usersCache.getUser((String) data.get("viewerId"));
            ArrayList<Object> commands = (ArrayList<Object>) data.get("queue");

            ArrayList<Object> response = new ArrayList<Object>();

            Iterator<Object> commandIt = commands.iterator();
            while (commandIt.hasNext())
            {
                HashMap<String, Object> commandData = (HashMap<String, Object>) commandIt.next();
                HashMap<String, Object> res = user.processCommand(commandData);
                res.put("cmd", commandData.get("cmd"));
                response.add(res);
            }


            sendOKStatus(ctx, response);
        } catch (Exception exc)
        {
            sendError(ctx, exc.getMessage());
        }
    }

    public void sendOKStatus(ChannelHandlerContext ctx, Object data)
    {
        Map<String, Object> responseData = new HashMap<String, Object>();
        responseData.put("status", "OK");
        responseData.put("queue", data);

        String responseDataJSON = JSON.serialize(responseData);

        HttpResponse response = new DefaultHttpResponse(HTTP_1_1, HttpResponseStatus.OK);
        response.setHeader(CONTENT_TYPE, "text/plain; charset=UTF-8");
        response.setContent(ChannelBuffers.copiedBuffer(
                responseDataJSON,
                CharsetUtil.UTF_8));

        ctx.getChannel().write(response).addListener(ChannelFutureListener.CLOSE);
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, ExceptionEvent e)
            throws Exception
    {
        logger.error(e.getCause().getMessage());

        String errorText = e.getCause().getMessage() + " :: " + e.getCause().getStackTrace().toString();
        sendError(ctx, errorText);
    }

    private void sendError(ChannelHandlerContext ctx, String errorText)
    {
        Map<String, Object> responseData = new HashMap<String, Object>();
        responseData.put("status", "Error");
        responseData.put("data", errorText);

        String responseDataJSON = JSON.serialize(responseData);

        HttpResponse response = new DefaultHttpResponse(HTTP_1_1, HttpResponseStatus.OK);
        response.setHeader(CONTENT_TYPE, "text/plain; charset=UTF-8");
        response.setContent(ChannelBuffers.copiedBuffer(
                responseDataJSON,
                CharsetUtil.UTF_8));

        ctx.getChannel().write(response).addListener(ChannelFutureListener.CLOSE);
    }

}
