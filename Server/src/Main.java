import db.DataBase;
import network.ServerPipelineFactory;
import org.apache.log4j.Logger;
import org.jboss.netty.bootstrap.ServerBootstrap;
import org.jboss.netty.channel.ChannelException;
import org.jboss.netty.channel.ChannelFactory;
import org.jboss.netty.channel.socket.nio.NioServerSocketChannelFactory;

import java.net.InetSocketAddress;
import java.net.UnknownHostException;
import java.util.concurrent.Executors;

public class Main
{
    private static final Logger logger = Logger.getLogger(Main.class);

    public static void main(String[] args)
    {
        init();
    }

    private static void init()
    {
        try
        {
            initLogger();
            initDBconnection();
            initMainServer();
        } catch (UnknownHostException e)
        {
            logger.error(e.getCause().getMessage());
            System.exit(-1);
        }
    }

    private static void initLogger()
    {
        org.apache.log4j.PropertyConfigurator.configure("./config/log4j.properties");

//        :::::::Uncomment to enable AMF3-Serializer debug trace::::::::
//        Logger log = Logger.getLogger(AMF3Deserializer.class);
//        Logger logMore = Logger.getLogger(AMF3Deserializer.class.getName() + ".MORE");
//        log.setLevel(Level.DEBUG);
//        logMore.setLevel(Level.DEBUG);
//        :::::::Uncomment to enable AMF3-Serializer debug trace::::::::
    }

    private static void initDBconnection() throws UnknownHostException
    {
        DataBase.inst().init();
        logger.info("DB connection inited");
    }

    private static void initMainServer()
    {
        ChannelFactory factory = new NioServerSocketChannelFactory(Executors.newCachedThreadPool(), Executors.newCachedThreadPool());
        ServerBootstrap bootstrap = new ServerBootstrap(factory);
        bootstrap.setPipelineFactory(new ServerPipelineFactory());
        bootstrap.setOption("child.tcpNoDelay", true);
        bootstrap.setOption("child.keepAlive", true);

        try
        {
            bootstrap.bind(new InetSocketAddress(9777));
        } catch (ChannelException exc)
        {
            System.out.println(exc.getCause().getMessage());
            System.exit(-1);
        }
        logger.info("User server started");
    }
}
