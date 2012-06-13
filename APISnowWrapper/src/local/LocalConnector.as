/**
 * Author: JuzTosS
 * Date: 10.06.12
 */
package local
{
import connectors.IAPIConnector;

import flash.display.DisplayObjectContainer;

import misc.IApplicationSettings;
import misc.SEX;
import misc.SUser;

public class LocalConnector implements IAPIConnector
{
    public function LocalConnector()
    {
    }


    public function init(stage_inst:DisplayObjectContainer, ...additional_params)
    {
        //do nothin
    }

    private var _current_user_inst:SUser;
    public function get current_user():SUser
    {
        if (!_current_user_inst) create_current_user();
        return current_user;
    }

    private function create_current_user():void
    {
        _current_user_inst = new SUser();
        _current_user_inst.birthdate = new Date(1988, 7, 3);
        _current_user_inst.city = "Javea";
        _current_user_inst.country = "Spain";
        _current_user_inst.first_name = "Kirill";
        _current_user_inst.id = "123450";
        _current_user_inst.last_name = "Keane";
        _current_user_inst.nickname = "JuzTosS";
        _current_user_inst.avatar_pic = "http://local_host/local_connector/kirill_avatar.jpg";
        _current_user_inst.sex = SEX.MALE;
    }

    private var _friends_inst:Array;
    public function get friends():Array
    {
        if (!_friends_inst) create_friends();
        return _friends_inst;
    }

    private function create_friends():void
    {
        const num_of_friends:uint = 5;

        for (var friend_num:int = 1; friend_num <= num_of_friends; friend_num++)
        {
            var new_friend:SUser = new SUser();

            new_friend = new SUser();
            new_friend.birthdate = new Date(1988, 7, 3);
            new_friend.city = "Javea";
            new_friend.country = "Spain";
            new_friend.first_name = "Friend " + friend_num.toString();
            new_friend.id = (123450 + friend_num).toString();
            new_friend.last_name = "Virtual";
            new_friend.nickname = "N.." + friend_num.toString();
            new_friend.avatar_pic = "http://local_host/local_connector/friend" + friend_num + ".jpg";
            new_friend.sex = SEX.MALE;

            _friends_inst.push(new_friend);
        }
    }

    public function get application_settings():IApplicationSettings
    {
        throw "Method not supported";
    }

    public function show_invite_wnd():void
    {
        throw "Method not supported";
    }

    public function show_payment_wnd(votes:uint):void
    {
        throw "Method not supported";
    }

    public function show_settings_wnd():void
    {
        throw "Method not supported";
    }

    public function wall_post(user:SUser, title_text:String = null, body_text:String = null, image_path:String = null):void
    {
        throw "Method not supported";
    }

    public function invite_friend(user:SUser):void
    {
        throw "Method not supported";
    }

    public function get_user_by_id(id:String):SUser
    {
        for each(var friend:SUser in friends)
        {
            if(friend.id == id) return friend;
        }

        throw "Method not supported";
        return null;
    }

}
}
