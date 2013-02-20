import db.DataBase;
import objects.UserState;
import objects.UserWorker;
import org.junit.Test;
import org.junit.Before;

import java.net.UnknownHostException;
import java.util.Arrays;
import java.util.HashMap;

import static org.junit.Assert.fail;

/**
 * Author: JuzTosS
 * Date: 02.11.12
 */
public class testUserWorker
{
    @Before
    public void setUp() throws UnknownHostException
    {
        DataBase.inst().init();
    }

    @Test
    public void TestCreateNew()
    {
        try
        {
            UserWorker userWorker = new UserWorker();
            userWorker.createNew("9999");
        } catch (Exception e)
        {
            System.out.println(e.getMessage());
            System.out.println(Arrays.toString(e.getStackTrace()));
            fail();
        }
    }

    @Test
    public void TestLoadUserState()
    {
        try
        {
            UserWorker userWorker = new UserWorker();
            UserState userState = new UserState();
            userWorker.load(userState);
        } catch (Exception e)
        {
            System.out.println(e.getMessage());
            System.out.println(Arrays.toString(e.getStackTrace()));
            fail();
        }
    }

    @Test
    public void TestCommands()
    {
        try
        {
            UserWorker userWorker = new UserWorker();

            HashMap<String, Object> voidCommand = new HashMap<String, Object>();
            userWorker.processCommand(voidCommand);


        } catch (Exception e)
        {
            System.out.println(e.getMessage());
            System.out.println(Arrays.toString(e.getStackTrace()));
            fail();
        }
    }
}
