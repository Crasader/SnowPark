/**
 * Author: JuzTosS
 * Date: 10.06.12
 */
package controllers
{
import basemvc.controller.CompositeController;

import events.ResponseEvent;
import events.UserEvent;
import events.UserViewEvent;

import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.UncaughtErrorEvent;

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

        _cameraController.addEventListener(UserEvent.TOOL_CHANGED, onToolChanged);

        _userModel = new UserModel();
        _userView = new UserView(_userModel);
        _parentView.addChild(_userView);

        _userView.addEventListener(UserEvent.ALL_FRIENDS, onAllFriends);
        _userView.addEventListener(UserEvent.BUILD, onBuild);
        _userView.addEventListener(UserEvent.SETTINGS, onSettings);
        _userView.addEventListener(UserEvent.TOOL_DOWN, onToolDown);
        _userView.addEventListener(UserEvent.TOOL_UP, onToolUp);
        _userView.addEventListener(UserEvent.TOOL_DESTROY, onToolDestroy);
        _userView.addEventListener(UserEvent.CANCEL, onCancel);

        init();
    }

    private function onToolChanged(event:UserEvent):void
    {
        _userView.onToolChanged(event);
    }

    private function onCancel(event:UserEvent):void
    {
        fieldController.fieldModel.setTool(FieldModel.VOID_TOOL);
    }

    private function onToolDestroy(event:UserEvent):void
    {
        fieldController.fieldModel.setTool(FieldModel.DESTROY_TOOL);
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
        fieldController.fieldModel.setTool(FieldModel.PLACE_OBJECT_TOOL, event.data);
    }

    private function onAllFriends(event:UserEvent):void
    {

    }

    private function init(e:Event = null):void
    {
        core.addEventListener(ResponseEvent.SNOW_RESPONSE, onResponse);
        Main.globalErrorDispatcher.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onGlobalError);
    }

    private function onGlobalError(e:UncaughtErrorEvent):void
    {
        _userView.dispatchEvent(new UserViewEvent(UserViewEvent.SHOW_POPUP, false,
                {
                    header :"Ошибка клиента",
                    content:(e.error as Object).toString()
                }));
    }

    private function onResponse(e:ResponseEvent):void
    {
        if (e.params["status"] == "Error")
        {
            _userView.dispatchEvent(new UserViewEvent(UserViewEvent.SHOW_POPUP, false,
                    {
                        header :"Ошибка сервера",
                        content:e.params["data"]
                    }));
        }
    }

    public function getModel():UserModel
    {
        return _userModel;
    }
}
}
