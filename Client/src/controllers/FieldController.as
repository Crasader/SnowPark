/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 08.04.12
 * Time: 1:06
 * To change this template use File | Settings | File Templates.
 */
package controllers
{
import as3isolib.display.IsoView;

import basemvc.controller.CompositeController;

import events.CommandEvent;
import events.CoreEvent;
import events.FieldEvent;
import events.ResponseEvent;
import events.UserEvent;

import flash.display.BitmapData;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import models.FieldModel;

import objects.ObjectController;
import objects.ObjectModel;

import utils.IntPnt;

import views.FieldView;

public class FieldController extends CompositeController
{
    private var _fieldView:FieldView;
    private var _fieldModel:FieldModel;
    private var _parentView:IsoView;

    public function FieldController(parentView:IsoView)
    {
        ObjectModel.registerComponets();

        _fieldModel = new FieldModel();
        core.addEventListener(CoreEvent.WORLD_TICK, _fieldModel.tick);
        core.addEventListener(CoreEvent.ENTER_FRAME, _fieldModel.onFrame);
        _parentView = parentView;
        _fieldView = new FieldView(_fieldModel, parentView);
        parentView.addScene(_fieldView);

        _fieldModel.addEventListener(Event.CHANGE, _fieldView.update);
        _fieldModel.addEventListener(FieldEvent.TOOL_CHANGED, onToolChanged);

        if (parentView.stage)
        {
            init();
        }
        else
        {
            parentView.addEventListener(Event.ADDED_TO_STAGE, init);
        }
    }

    private function init(event:Event = null):void
    {
        core.addEventListener(ResponseEvent.SNOW_RESPONSE, onResponse);
        _fieldView.addEventListener(FieldEvent.MOUSE_CLICK, onFieldClick);
        _fieldView.addEventListener(FieldEvent.MOUSE_MOVE, onMouseMove);
    }

    private function onMouseMove(event:FieldEvent):void
    {
        checkObjectCoollide(event, checkMove);
    }

    private function checkClick(obj:ObjectController, checked:Boolean):void
    {
        if (checked)
            obj.mouseClick();
    }

    private function checkMove(obj:ObjectController, checked:Boolean):void
    {
        if (checked) obj.mouseOn();
        else obj.mouseOff();
    }

    private function checkObjectCoollide(event:FieldEvent, checkF:Function):ObjectController //TODO: Оптимизировать поиск только по соседним с мышкой клеточкам
    {
        for (var i:int = 0; i < numChildren; i++)
        {
            var child:ObjectController = getChild(i) as ObjectController;
            if (!child) continue;

            var hitMask:BitmapData = child.getView().hitMask;
            var hitMaskPos:Point = child.getView().hitMaskPos;
            if (!hitMask) continue;

            var me:MouseEvent = event.targetEvent as MouseEvent;
            var xx:Number = me.stageX - hitMaskPos.x;
            var yy:Number = me.stageY - hitMaskPos.y;
            var value:uint = hitMask.getPixel32(xx, yy);

            checkF(child, value != 0);
        }

        return null;
    }

    private function onResponse(e:ResponseEvent):void
    {
        if (e.cmd == "getUserData" && e.params["type"] == "all")
        {
            reloadField(e.params["objects"], e.params["heightMap"]);
        }
    }

    private function updateUserState(responseParam:Array):void
    {
        //reloadField
    }

    private function reloadField(fieldObjects:Array, heightMap:Array):void
    {
        _fieldModel.clear();
        _fieldModel.heightMap = heightMap;

        while (numChildren)
            remove(getChild(0));

        for each(var objInfo:Object in fieldObjects)
        {
            var pos:IntPnt = new IntPnt(objInfo["x"], objInfo["y"]);
            var block:ObjectController = new ObjectController(objInfo["classId"], _fieldModel);
            if (_fieldModel.createObject(block.getModel(), pos))
            {
                _fieldView.addChild(block.getView());
                add(block);
            }
        }
    }

    private function onToolChanged(event:FieldEvent):void
    {
        var e:UserEvent = new UserEvent(UserEvent.TOOL_CHANGED, true);
        e.data = _fieldModel.activeTool;
        dispatchEvent(e);
    }

    private function onFieldClick(e:FieldEvent):void
    {
        if (_fieldModel.activeTool == FieldModel.DOWN_TOOL)
            decreaseGroundLevel(e);
        else if (_fieldModel.activeTool == FieldModel.UP_TOOL)
            increaseGroundLevel(e);
        else if (_fieldModel.activeTool == FieldModel.PLACE_OBJECT_TOOL)
            createObject(e);
        else if (_fieldModel.activeTool == FieldModel.DESTROY_TOOL)
            checkObjectCoollide(e, checkDestroy);
        else
        {
            checkObjectCoollide(e, checkClick);
        }

    }

    private function checkDestroy(obj:ObjectController, checked:Boolean):void
    {
        if (checked) destroyObject(obj);
    }

    private function destroyObject(obj:ObjectController):void
    {
        if (_fieldModel.destroy(obj.getModel()))
        {
            remove(obj);
            _fieldView.removeChild(obj.getView());
            var params:Object = {
                classId:obj.getModel().classId,
                spaceId:obj.getModel()._space,
                x      :obj.getModel().x,
                y      :obj.getModel().y
            };

            dispatchEvent(new CommandEvent("destroy",
                    params,
                    false, true));
        }

    }

    private function createObject(e:FieldEvent):void
    {

        var objId:String = _fieldModel.activeToolParams.toString();
        var block:ObjectController = new ObjectController(objId, _fieldModel);
        if (_fieldModel.createObject(block.getModel(), e.pos))
        {
            _fieldView.addChild(block.getView());
            add(block);

            var params:Object = {
                classId:block.getModel().classId,
                spaceId:block.getModel()._space,
                x      :e.pos.x,
                y      :e.pos.y
            };

            dispatchEvent(new CommandEvent("create",
                    params,
                    false, true));
        }
    }

    private function increaseGroundLevel(e:FieldEvent):void
    {
        var newHeight:int = _fieldModel.getHeight(e.pos.x, e.pos.y) + 1;
        if (_fieldModel.setHeight(e.pos.x, e.pos.y, newHeight))
        {
            var params:Object = {
                x     :e.pos.x,
                y     :e.pos.y,
                height:newHeight
            };

            dispatchEvent(new CommandEvent("changeHeight",
                    params,
                    false, true));
        }
    }

    private function decreaseGroundLevel(e:FieldEvent):void
    {
        var newHeight:int = _fieldModel.getHeight(e.pos.x, e.pos.y) - 1;
        if (_fieldModel.setHeight(e.pos.x, e.pos.y, newHeight))
        {
            var params:Object = {
                x     :e.pos.x,
                y     :e.pos.y,
                height:newHeight
            };

            dispatchEvent(new CommandEvent("changeHeight",
                    params,
                    false, true));
        }
    }

    public function get fieldView():FieldView
    {
        return _fieldView;
    }

    public function get fieldModel():FieldModel
    {
        return _fieldModel;
    }
}
}
