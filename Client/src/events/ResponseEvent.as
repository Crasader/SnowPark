/**
 * Author: JuzTosS
 * Date: 10.06.12
 */
package events
{
import flash.events.Event;

public class ResponseEvent extends Event
{
    private var _params:Object;
    private var _cmd:String;

    public static const SNOW_RESPONSE:String = "SNOW_RESPONSE";

    function ResponseEvent(cmd:String, params:Object, bubbles:Boolean = false, cancelable:Boolean = false):void
    {
        super(SNOW_RESPONSE, bubbles, cancelable);
        _params = params;
        _cmd = cmd;
    }

    override public function clone():Event
    {
        return new ResponseEvent(_cmd, _params, bubbles, cancelable);
    }

    public function get params():Object
    {
        return _params;
    }

    public function get cmd():String
    {
        return _cmd;
    }
}
}
