/**
 * Author: JuzTosS
 * Date: 10.06.12
 */
package events
{
import flash.events.Event;

public class CommandEvent extends Event
{
    private var _commandParams:Array;
    private var _commandId:int;

    private var _forceSend:Boolean;

    public static const SNOW_COMMAND:String = "SNOW_COMMAND";

    function CommandEvent(cmd:int, params:Array, force_send:Boolean = false, bubbles:Boolean = false, cancelable:Boolean = false):void
    {
        super(SNOW_COMMAND, bubbles, cancelable);
        _commandParams = params;
        _commandId = cmd;
        _forceSend = force_send;
    }

    override public function clone():Event
    {
        return new CommandEvent(_commandId, _commandParams, _forceSend, bubbles, cancelable);
    }

    override public function toString():String
    {
        return "Command: " + _commandId;
    }

    public function get commandParams():Array
    {
        return _commandParams;
    }

    public function get commandId():int
    {
        return _commandId;
    }

    public function get forceSend():Boolean
    {
        return _forceSend;
    }
}
}
