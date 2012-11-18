/**
 * Author: JuzTosS
 * Date: 07.11.12
 */
package events
{
import flash.events.Event;

public class CoreEvent extends Event
{
    public static const CONFIG_LOADED:String = "snow_config_loaded";
    public static const CONFIG_LOAD_ERROR:String = "snow_config_load_error";

    public static const WORLD_TICK:String = "SnowWorldTick";
    public static const ENTER_FRAME:String = "SnowEnterFrame";

    public var data:Object;

    public function CoreEvent(type:String, bubbles:Boolean = false)
    {
        super(type, bubbles);
    }

    override public function clone():Event
    {
        var newEvent:CoreEvent = new CoreEvent(type, bubbles);
        newEvent.data = data;
        return newEvent;
    }
}
}
