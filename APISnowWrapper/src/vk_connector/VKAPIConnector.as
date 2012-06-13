/**
 * Author: JuzTosS
 * Date: 30.05.12
 */
package vk_connector {
import connectors.*;
import connectors.IAPIConnector;

import flash.display.DisplayObjectContainer;

import misc.IApplicationSettings;

import misc.SUser;

import vk.APIConnection;

public class VKAPIConnector implements IAPIConnector
{

    public function VKAPIConnector()
    {
    }


    public function init(stage_inst:DisplayObjectContainer, ...additional_params)
    {
    }

    public function get current_user():SUser
    {
        return null;
    }

    public function get friends():Array
    {
        return null;
    }

    public function get application_settings():IApplicationSettings
    {
        return null;
    }

    public function show_invite_wnd():void
    {
    }

    public function show_payment_wnd(votes:uint):void
    {
    }

    public function show_settings_wnd():void
    {
    }

    public function wall_post(user:SUser, title_text:String = null, body_text:String = null, image_path:String = null):void
    {
    }

    public function invite_friend(user:SUser):void
    {
    }

    public function get_user_by_id(id:int):SUser
    {
        return null;
    }

//    private var _vk_api_connection:APIConnection;
//    private var _flash_vars:Object;
//
//    private var _on_balance_changed_callback:Function;
//    public function set on_balance_changed(callback:Function):void
//    {
//        if(_on_balance_changed_callback != null)
//            _vk_api_connection.removeEventListener('onBalanceChanged', _on_balance_changed_callback);
//        if(callback != null)
//        {
//            _on_balance_changed_callback = callback;
//            _vk_api_connection.addEventListener('onBalanceChanged', callback);
//        }
//    }
//
//    public function init(swf_stage:DisplayObjectContainer):void
//    {
//        var flashVars:Object = swf_stage.loaderInfo.parameters as Object;
//        _flash_vars = flashVars;
//        _vk_api_connection = new APIConnection(flashVars);
//    }
//
//    public function show_invite_box():void
//    {
//        _vk_api_connection.callMethod("showInviteBox");
//    }
//
//    public function show_payment_box(votes:uint):void
//    {
//        _vk_api_connection.callMethod("showPaymentBox", votes);
//    }
//
//    public function get_profiles(ids:Array, cb:Function):void
//    {
//        var uids:String = "";
//        for each(var id:String in ids)
//            uids += id + ",";
//
//        uids = uids.slice(0, uids.length - 1);
//
//        _vk_api_connection.api('getProfiles', {uids:uids}, cb, on_vk_api_error);
//    }
//
//    public function load_friends(listing:int, cb:Function = null):void
//    {
//        //TODO:
//    }
//
//    public function wallPost(user_id:String, title:String, text:String, picture_url:String, cb:Function = null):void
//    {
//        //TODO:
//    }
//
//    public function show_settings_box():void
//    {
//        _vk_api_connection.callMethod("showSettingsBox");
//    }
//
//    public function preprocess_first_request(command:Object):void
//    {
//        //TODO:
//    }
//
//    public function get_user_settings(cb:Function = null):void
//    {
//        _vk_api_connection.api("getUserSettings", {}, cb, on_vk_api_error);
//    }
//
//    public function get is_app_installed():Boolean
//    {
//        //TODO:
//        return false;
//    }
//
//    private function on_vk_api_error(data:Object):void{
//        trace("\n" + "VK api error: " + data.error_msg + "\n");
//    }
}
}
