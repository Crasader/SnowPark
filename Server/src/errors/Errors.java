package errors;

import org.apache.log4j.Logger;
import org.jboss.netty.channel.ExceptionEvent;

/**
 * Author: JuzTosS
 * Date: 17.06.12
 */
public class Errors
{
    public static final int NO_ERRORS = 0;
    public static final int ERROR = 1;

    public static void logError(Logger logger, Exception e)
    {
        logger.error(e.toString());
        for(int i = 0; i < e.getStackTrace().length; i++)
            System.out.println(e.getStackTrace()[i]);
        System.out.println("End of stack trace");
    }

    public static void logError(Logger logger, ExceptionEvent e)
    {
        logger.error(e.getCause().getMessage());
        logger.error(e.toString());
        for(int i = 0; i < e.getCause().getStackTrace().length; i++)
            System.out.println(e.getCause().getStackTrace()[i]);
        System.out.println("End of stack trace");
    }
}
