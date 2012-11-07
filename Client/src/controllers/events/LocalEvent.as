/**
 * Author: JuzTosS
 * Date: 07.11.12
 */
package controllers.events
{
import flash.events.Event;

public class LocalEvent extends Event
{
    public static const CONFIG_LOADED:String = "snow_config_loaded";
    public static const CONFIG_LOAD_ERROR:String = "snow_config_load_error";

    public var data:Object;

    public function LocalEvent(type:String, bubbles:Boolean)
    {
        super(type, bubbles);
    }

    override public function clone():Event
    {
        var newEvent:LocalEvent = new LocalEvent(type, bubbles);
        newEvent.data = data;
        return newEvent;
    }
}
}
