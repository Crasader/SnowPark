/**
 * Author: JuzTosS
 * Date: 10.06.12
 */
package controllers.events
{
import flash.events.Event;

public class ResponseEvent extends Event
{
    private var _response_params:Array;
    private var _command_id:int;

    public static const SNOW_RESPONSE:String = "SNOW_RESPONSE";

    function ResponseEvent(cmd:int, params:Array, bubbles:Boolean = false, cancelable:Boolean = false):void
    {
        super(SNOW_RESPONSE, bubbles, cancelable);
        _response_params = params;
        _command_id = cmd;
    }

    override public function clone():Event
    {
        return new ResponseEvent(_command_id, _response_params, bubbles, cancelable);
    }

    override public function toString():String
    {
        return "Command: " + _command_id;
    }

    public function get response_params():Array
    {
        return _response_params;
    }

    public function get command_id():int
    {
        return _command_id;
    }
}
}
