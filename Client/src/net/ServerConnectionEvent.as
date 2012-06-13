/**
 * Author: JuzTosS
 * Date: 11.06.12
 */
package net
{
import flash.events.Event;

public class ServerConnectionEvent extends Event
{
    public static const REQUEST_RECEIVED:String = "request received";
    public var _data:*;

    public function ServerConnectionEvent(type:String, data:* = null, bubbles:Boolean = false,cancelable:Boolean = false)
    {
        _data = data;
        super(type, bubbles, cancelable);
    }

    override public function clone():Event
    {
        return new ServerConnectionEvent(type, _data, bubbles, cancelable);
    }
}
}
