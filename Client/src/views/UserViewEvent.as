/**
 * Author: JuzTosS
 * Date: 11.06.12
 */
package views
{
import flash.events.Event;

public class UserViewEvent extends Event
{
    public static const AUTH:String = "UserViewAuth";
    public static const CREATE_NEW_USER:String = "UserViewCreateNewuUser";

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
