package network;

import com.mongodb.util.JSON;
import config.Constants;
import org.apache.log4j.Logger;
import org.jboss.netty.buffer.ChannelBuffer;
import org.jboss.netty.buffer.ChannelBuffers;
import org.jboss.netty.channel.ChannelFutureListener;
import org.jboss.netty.channel.ChannelHandlerContext;
import org.jboss.netty.channel.MessageEvent;
import org.jboss.netty.handler.codec.http.*;
import org.jboss.netty.util.CharsetUtil;
import utils.CryptUtil;

import java.net.URLDecoder;
import java.util.List;
import java.util.Map;

import static org.jboss.netty.handler.codec.http.HttpHeaders.Names.CONTENT_TYPE;
import static org.jboss.netty.handler.codec.http.HttpVersion.HTTP_1_1;

/**
 * Author: JuzTosS
 * Date: 19.11.12
 */
public class HttpGameServerHandler extends HttpGatewayServerHandler
{
    private static final Logger logger = Logger.getLogger(HttpGameServerHandler.class);

    private static final String UPDATE = "/update";
    private static final String GET_USER_DATA = "/getUserData";
    private static final String VK_CALLBACK = "/vk_callback";

    @Override
    public void messageReceived(ChannelHandlerContext ctx, MessageEvent e) throws Exception
    {
        HttpRequest request = (HttpRequest) e.getMessage();

//        if (!checkAuth(decodePost(request))){
//            sendError(ctx, HttpResponseStatus.FORBIDDEN);
//            return;
//        }

        System.out.println("messageRecieved " + request.getUri());

        String uri = request.getUri();
        if (uri.equals(UPDATE))
            processUpdate(ctx, decodePost(request));
        else if (uri.equals(GET_USER_DATA))
            processGetUserData(ctx, decodePost(request));
        else if (uri.equals(VK_CALLBACK))
            processVKCallback(ctx, request.getContent());
        else
            sendError(ctx, HttpResponseStatus.BAD_REQUEST);
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

    private boolean checkAuth(Object data)
    {
        Map<String, Object> dataHash = (Map<String, Object>) data;
        String clientAuthKey = (String) dataHash.get("authKey");
        String apiId = (String) dataHash.get("apiId");
        String viewerId = (String) dataHash.get("viewerId");

        String serverAuthKey = CryptUtil.hashString(apiId + "_" + viewerId + "_" + Constants.API_SECRET);

        System.out.println(serverAuthKey.equals(clientAuthKey));
        System.out.println(serverAuthKey);
        System.out.println(clientAuthKey);
        return (serverAuthKey.equals(clientAuthKey));
    }

    private Object decodePost(HttpRequest request) throws Exception
    {
        String contentStr = request.getContent().toString(CharsetUtil.UTF_8);
        String decodedContentStr = URLDecoder.decode(contentStr, "UTF-8");
        decodedContentStr = decodedContentStr.substring(5); //Вырезаем "data=" в начале строки, парсер не обрабатывает
        Object content = JSON.parse(decodedContentStr);
        return content;
    }

    private void processGetUserData(ChannelHandlerContext ctx, Object data)
    {
        //To change body of created methods use File | Settings | File Templates.
    }

    private void processUpdate(ChannelHandlerContext ctx, Object data)
    {
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
