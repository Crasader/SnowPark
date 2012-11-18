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

import net.spec.CREATEOBJECT;
import net.spec.GETUSERSTATE;

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
        if (e.commandId == GETUSERSTATE.ID)
        {
            updateUserState(e.responseParams);
        }
    }

    private function updateUserState(responseParam:Array):void
    {
        reloadField(responseParam[GETUSERSTATE.FIELD_OBJS], responseParam[GETUSERSTATE.HEIGHT_MAP]);
    }

    private function reloadField(fieldObjects:Array, heightMap:Array):void
    {
        _fieldModel.clear();
        _fieldModel.heightMap = heightMap;

        while (numChildren)
            remove(getChild(0));

        for each(var objInfo:Array in fieldObjects)
        {
            var pos:IntPnt = new IntPnt(objInfo[1], objInfo[2]); // x, y
            var block:ObjectController = new ObjectController(objInfo[0], _fieldModel); // class_id
            if (_fieldModel.placeObject(block.getModel(), pos))
            {
                _fieldView.addChild(block.getView());
                add(block);
            }
        }
    }

    private function onFieldClick(e:FieldEvent):void
    {
//        var currentHeight:int = _fieldModel.getHeight(e.pos.x, e.pos.y);
//        var newHeight:int = currentHeight;
//        if ((e.targetEvent as MouseEvent).ctrlKey)
//            newHeight--;
//        else
//            newHeight++;
//
//        if (_fieldModel.setHeight(e.pos.x, e.pos.y, newHeight))
//        {
//            dispatchEvent(new CommandEvent(CMDList.CHANGE_HEIGHT,
//                    [e.pos.x,
//                        e.pos.y,
//                        newHeight],
//                    false, true));
//        }

        var block:ObjectController = new ObjectController("1000", _fieldModel);
        if (_fieldModel.placeObject(block.getModel(), e.pos))
        {
            _fieldView.addChild(block.getView());
            add(block);
        }

        var params:Array = [];
        params[CREATEOBJECT.CLASS_ID] = block.getModel().classId;
        params[CREATEOBJECT.SPACE_ID] = block.getModel()._space;
        params[CREATEOBJECT.X] = e.pos.x;
        params[CREATEOBJECT.Y] = e.pos.y;

        dispatchEvent(new CommandEvent(CREATEOBJECT.ID,
                params,
                false, true));
    }

    public function get fieldView():FieldView
    {
        return _fieldView;
    }
}
}
