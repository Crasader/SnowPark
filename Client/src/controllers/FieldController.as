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

import flash.events.Event;

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
        _fieldView.update();

        if (parentView.stage)
            init();
        else
            parentView.addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(event:Event = null):void
    {
        core.addEventListener(ResponseEvent.SNOW_RESPONSE, onResponse);
        _fieldView.addEventListener(FieldEvent.MOUSE_CLICK, onFieldClick);
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
            if (_fieldModel.placeObject(block.getModel(), pos))
            {
                _fieldView.addChild(block.getView());
                add(block);
            }
        }
    }

    private function onFieldClick(e:FieldEvent):void
    {
        if (_fieldModel.activeTool == FieldModel.DOWN_TOOL)
            decreaceGroundLevel(e);
        if (_fieldModel.activeTool == FieldModel.UP_TOOL)
            encreaceGroundLevel(e);
        if (_fieldModel.activeTool == FieldModel.PLACE_OBJECT_TOOL)
            placeObject(e);
    }

    private function placeObject(e:FieldEvent):void
    {
        var block:ObjectController = new ObjectController("1000", _fieldModel);
        if (_fieldModel.placeObject(block.getModel(), e.pos))
        {
            _fieldView.addChild(block.getView());
            add(block);
        }

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

    private function encreaceGroundLevel(e:FieldEvent):void
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

    private function decreaceGroundLevel(e:FieldEvent):void
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
