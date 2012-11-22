/**
 * Author: JuzTosS
 * Date: 21.11.12
 */
package
{
import flash.events.Event;

public class SocWrapperEvent extends Event
{
    public static const USER_LOADED:String = "SWEUserLoaded";
    public static const FRIENDS_LOADED:String = "SWEFriendsLoaded";
    public static const SETTINGS_CHANGED:String = "SWESettingsChanged";

    public function SocWrapperEvent(type:String)
    {
        super(type);
    }

    override public function clone():Event
    {
        return new SocWrapperEvent(type);
    }
}
}
