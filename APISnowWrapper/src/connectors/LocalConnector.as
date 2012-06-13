/**
 * Author: JuzTosS
 * Date: 31.05.12
 */
package connectors
{
import flash.display.DisplayObjectContainer;

public class LocalConnector implements  IAPIConnector
{
    public function LocalConnector()
    {
    }

    public function set on_balance_changed(callback:Function):void
    {
    }

    public function init(appstage:DisplayObjectContainer):void
    {
    }

    public function show_invite_box():void
    {
    }

    public function show_payment_box(votes:uint):void
    {
    }

    public function get_profiles(uids:Array, cb:Function):void
    {
    }

    public function load_friends(listing:int, cb:Function = null):void
    {
    }

    public function wallPost(user_id:String, title:String, text:String, picture_url:String, cb:Function = null):void
    {
    }

    public function show_settings_box():void
    {
    }

    public function preprocess_first_request(command:Object):void
    {
    }

    public function get_user_settings(cb:Function = null):void
    {
    }

    public function get is_app_installed():Boolean
    {
        return false;
    }
}
}
