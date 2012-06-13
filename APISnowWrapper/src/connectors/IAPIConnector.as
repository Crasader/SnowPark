package connectors
{
import flash.display.DisplayObjectContainer;

import misc.IApplicationSettings;

import misc.SUser;

public interface IAPIConnector
{
    function init(stage_inst:DisplayObjectContainer, ... additional_params);

    //Getters
    function get current_user():SUser;
    function get friends():Array;
    function get application_settings():IApplicationSettings
    //windows
    function show_invite_wnd():void
    function show_payment_wnd(votes:uint):void
    function show_settings_wnd():void

    //requests
    function wall_post(user:SUser, title_text:String = null, body_text:String = null, image_path:String = null):void
    function invite_friend(user:SUser):void

    //misc
    function get_user_by_id(id:String):SUser

//    function set on_balance_changed(callback:Function):void;
//
//    function init(appstage:DisplayObjectContainer):void;
//
//    function show_invite_box():void;
//
//    function show_payment_box(votes:uint):void;
//
//    function get_profiles(uids:Array, cb:Function):void;
//
//    function load_friends(listing:int, cb:Function = null):void;
//
//    function wallPost(user_id:String, title:String, text:String, picture_url:String, cb:Function = null):void;
//
//    function show_settings_box():void;
//
//    function preprocess_first_request(command:Object):void;
//
//    function get_user_settings(cb:Function = null):void;
//
//    function get is_app_installed():Boolean;
}
}