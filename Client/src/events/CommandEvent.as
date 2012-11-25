/**
 * Author: JuzTosS
 * Date: 10.06.12
 */
package events
{
import flash.events.Event;

public class CommandEvent extends Event
{
    private var _commandParams:Object;
    private var _commandName:String;

    private var _forceSend:Boolean;

    public static const SEND_COMMAND:String = "SEND_COMMAND";

    function CommandEvent(cmd:String, params:Object, force_send:Boolean = false, bubbles:Boolean = false, cancelable:Boolean = false):void
    {
        super(SEND_COMMAND, bubbles, cancelable);
        _commandParams = params;
        _commandName = cmd;
        _forceSend = force_send;
    }

    override public function clone():Event
    {
        return new CommandEvent(_commandName, _commandParams, _forceSend, bubbles, cancelable);
    }

    public function get commandParams():Object
    {
        return _commandParams;
    }

    public function get commandName():String
    {
        return _commandName;
    }

    public function get forceSend():Boolean
    {
        return _forceSend;
    }
}
}
