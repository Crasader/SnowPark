package errors;

import network.Command;

/**
 * Author: JuzTosS
 * Date: 18.06.12
 */
public class GameException extends Exception
{
    private Command _cmd;
    public GameException(Command cmd)
    {
        _cmd = cmd;
    }

    public GameException()
    {

    }

    public Command getCmd()
    {
        return _cmd;
    }
}
