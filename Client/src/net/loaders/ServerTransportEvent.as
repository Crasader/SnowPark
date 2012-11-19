/**
 * Author: JuzTosS
 * Date: 11.06.12
 */
package net.loaders
{
import flash.events.Event;

public class ServerTransportEvent extends Event
{
    public static const RESPONSE:String = "ServerTransportEventResponse";
    public static const ERROR:String = "ServerTransportEventError";
    public var _data:*;

    public function ServerTransportEvent(type:String, data:* = null, bubbles:Boolean = false,cancelable:Boolean = false)
    {
        _data = data;
        super(type, bubbles, cancelable);
    }

    override public function clone():Event
    {
        return new ServerTransportEvent(type, _data, bubbles, cancelable);
    }
}
}
