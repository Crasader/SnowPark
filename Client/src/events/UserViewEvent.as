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
    public static const SHOW_POPUP:String = "UVEShowPopup";
    public static const CLOSE_WND:String = "UVECloseWnd";

    private var _params:Object;

    public function UserViewEvent(type:String, bubbles:Boolean = false, params:Object = null)
    {
        _params = params;
        super(type, bubbles, cancelable);
    }

    override public function clone():Event
    {
        return new UserViewEvent(type, bubbles, params);
    }

    public function get params():Object
    {
        return _params;
    }
}
}
