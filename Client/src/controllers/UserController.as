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
import flash.events.Event;

import models.UserModel;

import views.UserView;
import views.UserViewEvent;

public class UserController extends CompositeController
{

    private var _userView:UserView;
    private var _userModel:UserModel;
    private var _parentView:DisplayObjectContainer;

    public function UserController(parentView:DisplayObjectContainer)
    {
        _parentView = parentView;
        var cameraController:CameraController = new CameraController(_parentView);
        add(cameraController);

        _userModel = new UserModel();
        _userView = new UserView(_userModel);
        _parentView.addChild(_userView);

        _userView.addEventListener(UserViewEvent.AUTH, onAuth);
        _userView.addEventListener(UserViewEvent.CREATE_NEW_USER, onCreateNew);

        init();
    }

    private function onCreateNew(e:UserViewEvent):void
    {
        _userModel._login = _userView.loginStr;
        _userModel._password = _userView.passStr;

        dispatchEvent(new CommandEvent(CMDList.CREATE_USER, [_userModel._login, _userModel.passHash], true, true));
    }

    private function onAuth(e:UserViewEvent):void
    {
        _userModel._login = _userView.loginStr;
        _userModel._password = _userView.passStr;

        dispatchEvent(new CommandEvent(CMDList.AUTH, [_userModel._login, _userModel.passHash], true, true));
    }

    private function init(e:Event = null):void
    {
        core.addEventListener(ResponseEvent.SNOW_RESPONSE, onResponse);
    }

    private function onResponse(e:ResponseEvent):void
    {
        if (e.commandId == CMDList.AUTH)
        {
            if (e.responseParams[0] != 0)
            {
                _userModel.auth_passed();
                dispatchEvent(new CommandEvent(CMDList.GET_USER_STATE, [], true, true));
            }
        }
    }

    public function getModel():UserModel
    {
        return _userModel;
    }
}
}
