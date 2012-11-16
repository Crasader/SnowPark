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

import controllers.events.CMDList;
import controllers.events.CommandEvent;
import controllers.events.FieldEvent;
import controllers.events.ResponseEvent;

import flash.events.Event;
import flash.events.MouseEvent;

import models.FieldModel;

import park.BaseSpaceObjectController;

import utils.IntPnt;

import views.FieldView;

public class FieldController extends CompositeController
{
    private var _fieldView:FieldView;
    private var _fieldModel:FieldModel;
    private var _parentView:IsoView;

    public function FieldController(parentView:IsoView)
    {
        _fieldModel = new FieldModel();
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
        if (e.commandId == CMDList.GET_USER_STATE)
        {
            updateUserState(e.responseParams);
        }
    }

    private function updateUserState(responseParam:Array):void
    {
        reloadField(responseParam[0], responseParam[1]);
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
            var block:BaseSpaceObjectController = new BaseSpaceObjectController(objInfo[0]); // class_id
            if (_fieldModel.placeObject(block.getModel(), pos))
            {
                _fieldView.addChild(block.getView());
                add(block);
            }
        }
    }

    private function onFieldClick(e:FieldEvent):void
    {
        var currentHeight:int = _fieldModel.getHeight(e.pos.x, e.pos.y);
        var newHeight:int = currentHeight;
        if ((e.targetEvent as MouseEvent).ctrlKey)
            newHeight--;
        else
            newHeight++;

        if (_fieldModel.setHeight(e.pos.x, e.pos.y, newHeight))
        {
            dispatchEvent(new CommandEvent(CMDList.CHANGE_HEIGHT,
                    [e.pos.x,
                        e.pos.y,
                        newHeight],
                    false, true));
        }
//        var isoPnt:Pt = _parentView.localToIso(new Point(e.stageX, e.stageY));
//        var pos:IntPnt = new IntPnt(isoPnt.x / FieldView.CELL_SIZE, isoPnt.y / FieldView.CELL_SIZE);
//
//        var block:BaseSpaceObjectController = new BaseSpaceObjectController("0");
//        if (_fieldModel.placeObject(block.getModel(), pos))
//        {
//            _fieldView.addChild(block.getView());
//            add(block);
//        }
//
//        dispatchEvent(new CommandEvent(CMDList.CREATE_OBJECT_ON_SPACE,
//                [block.getModel().classId,
//                    block.getModel()._group,
//                    pos.x,
//                    pos.y,
//                    block.getModel()._width,
//                    block.getModel()._length],
//                false, true));
    }

    public function get fieldView():FieldView
    {
        return _fieldView;
    }
}
}
