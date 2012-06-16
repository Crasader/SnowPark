/**
 * Author: JuzTosS
 * Date: 10.06.12
 */
package controllers
{
import basemvc.controller.CompositeController;

import com.junkbyte.console.Cc;

import controllers.events.CMDList;
import controllers.events.CommandEvent;
import controllers.events.ResponseEvent;

import flash.display.DisplayObjectContainer;

import models.UserModel;

import views.UserView;
import views.UserViewEvent;

public class UserController extends CompositeController
{

    private var _user_view:UserView;

    public function UserController(parent_view:DisplayObjectContainer)
    {
        var cameraController:CameraController = new CameraController(parent_view);
        add(cameraController);

        _user_view = new UserView();
        parent_view.addChild(_user_view);
        _user_view.addEventListener(UserViewEvent.AUTH, on_auth);
        _user_view.addEventListener(UserViewEvent.CREATE_NEW_USER, on_create_new);
        init();
    }

    private function on_create_new(e:UserViewEvent):void
    {
        UserModel.instanse._login = _user_view.login_str;
        UserModel.instanse._password = _user_view.pass_str;

        dispatchEvent(new CommandEvent(CMDList.CREATE_USER, [UserModel.instanse._login, UserModel.instanse.pass_hash], true));
    }

    private function on_auth(e:UserViewEvent):void
    {
        UserModel.instanse._login = _user_view.login_str;
        UserModel.instanse._password = _user_view.pass_str;

        dispatchEvent(new CommandEvent(CMDList.AUTH, [UserModel.instanse._login, UserModel.instanse.pass_hash], true));
    }

    private function init():void
    {
        _core.addEventListener(ResponseEvent.SNOW_RESPONSE, on_response);
    }

    private function on_response(e:ResponseEvent):void
    {
        if (e.command_id == CMDList.AUTH)
        {
            if(e.response_params[0] != 0)
                UserModel.instanse.auth_passed();
        }
    }

    public function getModel():UserModel
    {
        return UserModel.instanse;
    }
}
}
