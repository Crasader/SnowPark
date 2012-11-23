/**
 * Author: JuzTosS
 * Date: 10.06.12
 */
package controllers
{
import basemvc.controller.CompositeController;

import events.ResponseEvent;
import events.UserEvent;

import flash.display.DisplayObjectContainer;
import flash.events.Event;

import models.FieldModel;
import models.UserModel;

import views.UserView;

public class UserController extends CompositeController
{

    private var _userView:UserView;
    private var _userModel:UserModel;
    private var _parentView:DisplayObjectContainer;

    private var _cameraController:CameraController;

    public function UserController(parentView:DisplayObjectContainer)
    {
        _parentView = parentView;
        _cameraController = new CameraController(_parentView);
        add(_cameraController);

        _userModel = new UserModel();
        _userView = new UserView(_userModel);
        _parentView.addChild(_userView);

        _userView.addEventListener(UserEvent.ALL_FRIENDS, onAllFriends);
        _userView.addEventListener(UserEvent.BUILD, onBuild);
        _userView.addEventListener(UserEvent.SETTINGS, onSettings);
        _userView.addEventListener(UserEvent.TOOL_DOWN, onToolDown);
        _userView.addEventListener(UserEvent.TOOL_UP, onToolUp);
        init();
    }

    private function get fieldController():FieldController
    {
        return _cameraController.fieldController;
    }

    private function onToolUp(event:UserEvent):void
    {
        fieldController.fieldModel.setTool(FieldModel.UP_TOOL);
    }

    private function onToolDown(event:UserEvent):void
    {
        fieldController.fieldModel.setTool(FieldModel.DOWN_TOOL);
    }

    private function onSettings(event:UserEvent):void
    {

    }

    private function onBuild(event:UserEvent):void
    {
        fieldController.fieldModel.setTool(FieldModel.PLACE_OBJECT_TOOL);
    }

    private function onAllFriends(event:UserEvent):void
    {

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
