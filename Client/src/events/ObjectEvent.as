/**
 * Author: JuzTosS
 * Date: 17.11.12
 */
package events
{
import flash.events.Event;

public class ObjectEvent extends Event
{
    public static const POSITION_UPDATED:String = "SnowPositionUpdated";

    public function ObjectEvent(type:String)
    {
        super(type);
    }

    override public function clone():Event
    {
        return new ObjectEvent(type);
    }
}
}
