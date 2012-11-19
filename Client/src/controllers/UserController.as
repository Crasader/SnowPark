/**
 * Author: JuzTosS
 * Date: 10.06.12
 */
package controllers
{
import basemvc.controller.CompositeController;

import events.ResponseEvent;

import flash.display.DisplayObjectContainer;
import flash.events.Event;

import models.UserModel;

import views.UserView;

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

        init();
    }

    private function init(e:Event = null):void
    {
        core.addEventListener(ResponseEvent.SNOW_RESPONSE, onResponse);
    }

    private function onResponse(e:ResponseEvent):void
    {

    }

    public function getModel():UserModel
    {
        return _userModel;
    }
}
}
