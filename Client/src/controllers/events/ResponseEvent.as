/**
 * Author: JuzTosS
 * Date: 10.06.12
 */
package controllers.events
{
import flash.events.Event;

public class ResponseEvent extends Event
{
    private var _responseParams:Array;
    private var _commandId:int;

    public static const SNOW_RESPONSE:String = "SNOW_RESPONSE";

    function ResponseEvent(cmd:int, params:Array, bubbles:Boolean = false, cancelable:Boolean = false):void
    {
        super(SNOW_RESPONSE, bubbles, cancelable);
        _responseParams = params;
        _commandId = cmd;
    }

    override public function clone():Event
    {
        return new ResponseEvent(_commandId, _responseParams, bubbles, cancelable);
    }

    override public function toString():String
    {
        return "Command: " + _commandId;
    }

    public function get responseParams():Array
    {
        return _responseParams;
    }

    public function get commandId():int
    {
        return _commandId;
    }
}
}
