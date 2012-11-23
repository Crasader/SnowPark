/**
 * Author: JuzTosS
 * Date: 23.11.12
 */
package events
{
import flash.events.Event;

public class UserEvent extends Event
{
    public static const TOOL_UP:String = "UEToolUp";
    public static const TOOL_DOWN:String = "UEToolDown";
    public static const SETTINGS:String = "UESettings";
    public static const ALL_FRIENDS:String = "UEAllFriends";
    public static const BUILD:String = "UEBuild";
    public static const MONEY:String = "UEMoney";
    public static const EXP:String = "UEExp";
    public static const REAL:String = "UEReal";

    public function UserEvent(type:String)
    {
        super(type);
    }

    override public function clone():Event
    {
        return super.clone();
    }
}
}
