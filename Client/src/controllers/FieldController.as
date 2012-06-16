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
import as3isolib.display.primitive.IsoBox;
import as3isolib.geom.Pt;

import basemvc.controller.CompositeController;

import controllers.events.CMDList;

import controllers.events.CommandEvent;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import models.FieldModel;

import park.static.SpaceObjController;

import utils.IntPnt;

import views.FieldView;

public class FieldController extends CompositeController
{
    private var _fieldView:FieldView;
    private var _parentView:IsoView;
    
    public function FieldController(parent_view:IsoView)
    {
        _parentView = parent_view;
        _fieldView = new FieldView();
        parent_view.addScene(_fieldView);

        FieldModel.instanse.addEventListener(Event.CHANGE, _fieldView.update);
        _fieldView.update();

        
        if(parent_view.stage)
            init();
        else
            parent_view.addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(event:Event = null):void
    {
        (event.target as DisplayObject).stage.addEventListener(MouseEvent.CLICK, on_click);
    }

    private function on_click(e:MouseEvent):void
    {

        var iso_pt:Pt = _parentView.localToIso(new Point(e.stageX, e.stageY));
        var pos:IntPnt = new IntPnt(iso_pt.x / FieldView.CELL_SIZE, iso_pt.y / FieldView.CELL_SIZE);


        var block:SpaceObjController = new SpaceObjController();
        if(FieldModel.instanse.placeObject(block.getModel(), pos))
        {
            _fieldView.addChild(block.getView());
            add(block);
        }

        dispatchEvent(new CommandEvent(CMDList.CREATE_OBJECT_ON_SPACE,
                [block.getModel()._id,
                block.getModel()._group,
                pos.x,
                pos.y,
                block.getModel()._width,
                block.getModel()._length],
            true));
    }


    public function get fieldView():FieldView
    {
        return _fieldView;
    }
}
}
