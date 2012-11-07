/**
 * Author: JuzTosS
 * Date: 10.06.12
 */
package controllers
{
import basemvc.controller.CompositeController;

import controllers.events.CMDList;
import controllers.events.CommandEvent;
import controllers.events.ResponseEvent;

import flash.display.DisplayObjectContainer;

import models.UserModel;

import views.UserView;
import views.UserViewEvent;

public class UserController extends CompositeController
{

    private var _userView:UserView;

    public function UserController(parentView:DisplayObjectContainer)
    {
        var cameraController:CameraController = new CameraController(parentView);
        add(cameraController);

        _userView = new UserView();
        parentView.addChild(_userView);
        _userView.addEventListener(UserViewEvent.AUTH, onAuth);
        _userView.addEventListener(UserViewEvent.CREATE_NEW_USER, onCreateNew);
        init();
    }

    private function onCreateNew(e:UserViewEvent):void
    {
        UserModel.instanse._login = _userView.loginStr;
        UserModel.instanse._password = _userView.passStr;

        dispatchEvent(new CommandEvent(CMDList.CREATE_USER, [UserModel.instanse._login, UserModel.instanse.passHash], true, true));
    }

    private function onAuth(e:UserViewEvent):void
    {
        UserModel.instanse._login = _userView.loginStr;
        UserModel.instanse._password = _userView.passStr;

        dispatchEvent(new CommandEvent(CMDList.AUTH, [UserModel.instanse._login, UserModel.instanse.passHash], true, true));
    }

    private function init():void
    {
        CoreController.instanse.addEventListener(ResponseEvent.SNOW_RESPONSE, onResponse);
    }

    private function onResponse(e:ResponseEvent):void
    {
        if (e.commandId == CMDList.AUTH)
        {
            if (e.responseParams[0] != 0)
            {
                UserModel.instanse.auth_passed();
                dispatchEvent(new CommandEvent(CMDList.GET_USER_STATE, [], true, true));
            }
        }
    }

    public function getModel():UserModel
    {
        return UserModel.instanse;
    }
}
}
