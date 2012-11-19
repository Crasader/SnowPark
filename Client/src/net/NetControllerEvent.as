/**
 * Author: JuzTosS
 * Date: 19.11.12
 */
package net
{
import flash.events.Event;

public class NetControllerEvent extends Event
{
    public static var ERROR:String = "SnowNetControllerError";
    public static var RESPONSE:String = "SnowNetControllerResponse";

    private var _data:String;

    public function NetControllerEvent(type:String, dataString:String = "")
    {
        _data = dataString;
        super(type);
    }

    override public function clone():Event
    {
        return new NetControllerEvent(type, data);
    }

    public function get data():String
    {
        return _data;
    }
}
}
