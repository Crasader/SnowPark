/**
 * Author: JuzTosS
 * Date: 10.06.12
 */
package controllers.events
{
import avmplus.factoryXml;

import flash.events.Event;

public class CommandEvent extends Event
{
    private var _command_params:Array;
    private var _command_id:int;

    private var _force_send:Boolean;

    public static const SNOW_COMMAND:String = "SNOW_COMMAND";

    function CommandEvent(cmd:int, params:Array, force_send:Boolean = false, bubbles:Boolean = false, cancelable:Boolean = false):void
    {
        super(SNOW_COMMAND, bubbles, cancelable);
        _command_params = params;
        _command_id = cmd;
        _force_send = force_send;
    }

    override public function clone():Event
    {
        return new CommandEvent(_command_id, _command_params, _force_send, bubbles, cancelable);
    }

    override public function toString():String
    {
        return "Command: " + _command_id;
    }

    public function get command_params():Array
    {
        return _command_params;
    }

    public function get command_id():int
    {
        return _command_id;
    }

    public function get force_send():Boolean
    {
        return _force_send;
    }
}
}
