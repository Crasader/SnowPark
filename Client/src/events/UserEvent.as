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

	public var data:Object;

	public function UserEvent(type:String, bubbles:Boolean = false)
	{
		super(type, bubbles);
	}

	override public function clone():Event
	{
		var e:UserEvent = new UserEvent(type, bubbles);
		e.data = data;
		return e;
	}
}
}
