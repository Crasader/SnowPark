/**
 * Author: JuzTosS
 * Date: 10.06.12
 */
package controllers
{
import basemvc.controller.CompositeController;

import events.CommandEvent;
import events.ResponseEvent;

import flash.display.DisplayObjectContainer;
import flash.events.Event;

import models.UserModel;

import net.spec.AUTH;
import net.spec.CREATEUSER;
import net.spec.GETUSERSTATE;

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

        var params:Array = [];
        params[AUTH.LOGIN] = _userModel._login;
        params[AUTH.PASSWORD] = _userModel.passHash;

        dispatchEvent(new CommandEvent(CREATEUSER.ID, params, true, true));
    }

    private function onAuth(e:UserViewEvent):void
    {
        _userModel._login = _userView.loginStr;
        _userModel._password = _userView.passStr;

        var params:Array = [];
        params[AUTH.LOGIN] = _userModel._login;
        params[AUTH.PASSWORD] = _userModel.passHash;

        dispatchEvent(new CommandEvent(AUTH.ID, params, true, true));
    }

    private function init(e:Event = null):void
    {
        core.addEventListener(ResponseEvent.SNOW_RESPONSE, onResponse);
    }

    private function onResponse(e:ResponseEvent):void
    {
        if (e.commandId == AUTH.ID)
        {
            if (e.responseParams[0] != 0)
            {
                _userModel.auth_passed();
                dispatchEvent(new CommandEvent(GETUSERSTATE.ID, [], true, true));
            }
        }
    }

    public function getModel():UserModel
    {
        return _userModel;
    }
}
}
