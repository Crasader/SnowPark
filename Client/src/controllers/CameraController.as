/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 08.04.12
 * Time: 1:41
 * To change this template use File | Settings | File Templates.
 */
package controllers
{
import basemvc.controller.CompositeController;

import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import models.CameraModel;

import views.CameraView;

public class CameraController extends CompositeController
{
    private var _cameraView:CameraView;
    private var _cameraModel:CameraModel;

    private var _mousePressed:Boolean = false;
    private var _lastMouseDownPos:Point = new Point();
    private var _lastMouseDownCameraPos:Point = new Point();
    private var _mouseMoved:Boolean = false;
    private var _lastMouseMoveEvent:MouseEvent;

    private var _fieldController:FieldController;

    public function CameraController(parentView:DisplayObjectContainer)
    {
        _cameraModel = new CameraModel();
        _cameraView = new CameraView(_cameraModel);
        parentView.addChild(_cameraView);

        _fieldController = new FieldController(_cameraView);
        add(_fieldController);

        if (_cameraView.stage)
            init();
        else
            _cameraView.addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(e:Event = null):void
    {
        _cameraView.removeEventListener(Event.ADDED_TO_STAGE, init);

        _cameraView.stage.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
        _cameraView.stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
        _cameraView.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        _cameraView.addEventListener(Event.ENTER_FRAME, onEnterFrame);
        _cameraView.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
    }

    private function onWheel(event:MouseEvent):void
    {
        if (event.delta > 0)
            _cameraModel.zoomUp();
        else
            _cameraModel.zoomDown();
    }

    private function onMouseMove(event:MouseEvent):void
    {
        _mouseMoved = true;
        _lastMouseMoveEvent = event;
    }

    private function onEnterFrame(event:Event):void
    {
        if (_mouseMoved)
        {
            _mouseMoved = false;
            mouseMoveImpl(_lastMouseMoveEvent);
        }

    }

    private function mouseMoveImpl(e:MouseEvent):void
    {
        if (_mousePressed)
        {
            _cameraModel.setPostion(_lastMouseDownCameraPos.x - ( _lastMouseDownPos.x - e.stageX) / _cameraModel._zoom
                    , _lastMouseDownCameraPos.y - (_lastMouseDownPos.y - e.stageY) / _cameraModel._zoom);
        }
    }

    private function onUp(e:MouseEvent):void
    {
        _mousePressed = false;
    }

    private function onDown(e:MouseEvent):void
    {
        _lastMouseDownCameraPos.x = _cameraModel._x;
        _lastMouseDownCameraPos.y = _cameraModel._y;
        _lastMouseDownPos.x = e.stageX;
        _lastMouseDownPos.y = e.stageY;
        _mousePressed = true;
    }

    public function get fieldController():FieldController
    {
        return _fieldController;
    }
}
}
