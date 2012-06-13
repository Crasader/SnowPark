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

    private var _mouse_pressed:Boolean = false;
    private var _last_mouse_down_pos:Point = new Point();
    private var _last_mouse_down_camera_pos:Point = new Point();
    private var _mouse_moved:Boolean = false;
    private var _last_mouse_move_event:MouseEvent;
    

    public function CameraController(parent_view:DisplayObjectContainer)
    {
        _cameraView = new CameraView();
        parent_view.addChild(_cameraView);

        var field_controller:FieldController = new FieldController(_cameraView);
        add(field_controller);

        if(_cameraView.stage)
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
        if(event.delta > 0)
            CameraModel.instanse.zoom_up();
        else
            CameraModel.instanse.zoom_down();
    }

    private function onMouseMove(event:MouseEvent):void
    {
        _mouse_moved = true;
        _last_mouse_move_event = event;
    }

    private function onEnterFrame(event:Event):void
    {
        if(_mouse_moved)
        {
            _mouse_moved = false;
            mouse_move_impl(_last_mouse_move_event);
        }


    }

    private function mouse_move_impl(e:MouseEvent):void
    {
        if(_mouse_pressed)
        {
            CameraModel.instanse.set_postion(_last_mouse_down_camera_pos.x - ( _last_mouse_down_pos.x - e.stageX) / CameraModel.instanse._zoom
                                            , _last_mouse_down_camera_pos.y -  (_last_mouse_down_pos.y - e.stageY) / CameraModel.instanse._zoom);
        }
    }

    private function onUp(e:MouseEvent):void
    {
        _mouse_pressed = false;
    }

    private function onDown(e:MouseEvent):void
    {
        _last_mouse_down_camera_pos.x = CameraModel.instanse._x;
        _last_mouse_down_camera_pos.y = CameraModel.instanse._y;
        _last_mouse_down_pos.x = e.stageX
        _last_mouse_down_pos.y = e.stageY
        _mouse_pressed = true;
    }

    
}
}
