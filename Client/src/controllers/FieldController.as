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
import as3isolib.geom.Pt;

import basemvc.controller.CompositeController;

import controllers.events.CMDList;
import controllers.events.CommandEvent;
import controllers.events.ResponseEvent;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import models.FieldModel;

import park.BaseSpaceObjectController;

import utils.IntPnt;

import views.FieldView;

public class FieldController extends CompositeController
{
    private var _fieldView:FieldView;
    private var _parentView:IsoView;

    public function FieldController(parentView:IsoView)
    {
        _parentView = parentView;
        _fieldView = new FieldView();
        parentView.addScene(_fieldView);

        FieldModel.instanse.addEventListener(Event.CHANGE, _fieldView.update);
        _fieldView.update();

        if (parentView.stage)
            init();
        else
            parentView.addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(event:Event = null):void
    {
        CoreController.instanse.addEventListener(ResponseEvent.SNOW_RESPONSE, onResponse);
        _parentView.stage.addEventListener(MouseEvent.CLICK, onClick);
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
        reloadField(responseParam[0]);
    }

    private function reloadField(fieldObjects:Array):void
    {
        FieldModel.instanse.clear();
        _fieldView.removeAllChildren();

        while (numChildren)
            remove(getChild(0));

        for each(var objInfo:Array in fieldObjects)
        {
            var pos:IntPnt = new IntPnt(objInfo[2], objInfo[3]); // x, y
            var block:BaseSpaceObjectController = new BaseSpaceObjectController(objInfo[0], objInfo[1]); // obj_id, class_id
            if (FieldModel.instanse.placeObject(block.getModel(), pos))
            {
                _fieldView.addChild(block.getView());
                add(block);
            }
        }
    }

    private function onClick(e:MouseEvent):void
    {

        var isoPnt:Pt = _parentView.localToIso(new Point(e.stageX, e.stageY));
        var pos:IntPnt = new IntPnt(isoPnt.x / FieldView.CELL_SIZE, isoPnt.y / FieldView.CELL_SIZE);

        var block:BaseSpaceObjectController = new BaseSpaceObjectController(12345, "1");
        if (FieldModel.instanse.placeObject(block.getModel(), pos))
        {
            _fieldView.addChild(block.getView());
            add(block);
        }

        dispatchEvent(new CommandEvent(CMDList.CREATE_OBJECT_ON_SPACE,
                [block.getModel().objectId,
                    block.getModel().classId,
                    block.getModel()._group,
                    pos.x,
                    pos.y,
                    block.getModel()._width,
                    block.getModel()._length],
                false, true));
    }

    public function get fieldView():FieldView
    {
        return _fieldView;
    }
}
}
