/**
 * Author: JuzTosS
 * Date: 11.06.12
 */
package views
{
import flash.events.Event;

public class UserViewEvent extends Event
{
    public function UserViewEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
    {
        super(type, bubbles, cancelable);
    }

    override public function clone():Event
    {
        return super.clone();
    }
}
}
