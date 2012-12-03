/**
 * Author: JuzTosS
 * Date: 11.06.12
 */
package events
{
import flash.events.Event;

public class UserViewEvent extends Event
{
	public static const SHOW_SHOP_WND:String = "UVEShowShopWindow";
	public static const CLOSE_WND:String = "UVECloseWnd";

	public function UserViewEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
	{
		super(type, bubbles, cancelable);
	}

	override public function clone():Event
	{
		return new UserViewEvent(type, bubbles, cancelable);
	}
}
}
