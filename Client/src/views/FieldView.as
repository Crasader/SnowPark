/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 08.04.12
 * Time: 1:11
 * To change this template use File | Settings | File Templates.
 */
package views
{
import as3isolib.data.INode;
import as3isolib.display.IsoSprite;
import as3isolib.display.IsoView;
import as3isolib.display.scene.IsoScene;
import as3isolib.geom.IsoMath;
import as3isolib.geom.Pt;

import config.Constants;

import events.FieldEvent;
import events.UserEvent;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.text.TextField;

import models.IFieldModel;

import utils.IntPnt;

public class FieldView extends IsoScene
{
    private var _model:IFieldModel;

    private var _heightMouseMap:Bitmap = new Bitmap(new BitmapData(fieldMaxWidth, fieldMaxHeight + Constants.MOUSEMAP_HEIGHT_MARGIN));
    private var _heightMouseHash:Array;
    private var _heightMouseColors:Object = {};

    private var _parentView:IsoView;
    private var _selectedSellOfGrid:Sprite = new Sprite();
    private var _grid:Bitmap = new Bitmap(new BitmapData(fieldMaxWidth, fieldMaxHeight + Constants.MOUSEMAP_HEIGHT_MARGIN, true, 0xFF0000));
    private var _field:Bitmap = new Bitmap(new BitmapData(fieldMaxWidth, fieldMaxHeight + Constants.MOUSEMAP_HEIGHT_MARGIN));
    private var _gridLayer:IsoSprite = new IsoSprite();

    private var _mouseMovedAfterDown:MouseEvent;
    private var _mouseMovedAfterFrame:MouseEvent;

    public function FieldView(model:IFieldModel, parentView:IsoView)
    {
        _model = model;
        _parentView = parentView;
        _parentView.mouseChildren = false;

        _model.addEventListener(FieldEvent.HEIGHTMAP_CHANGED, onHeightMapChanged);
        _model.addEventListener(FieldEvent.OBJECT_ADDED, onObjectAdded);
        _parentView.addEventListener(Event.ENTER_FRAME, onEnterFrame);
        _parentView.stage.addEventListener(MouseEvent.CLICK, onClick);
        _parentView.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        _parentView.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

        _gridLayer.sprites = [_field, _grid, _selectedSellOfGrid];
        _grid.x = -fieldMaxWidth / 2;
        _grid.y = -Constants.MOUSEMAP_HEIGHT_MARGIN;
        _field.x = -fieldMaxWidth / 2;
        _field.y = -Constants.MOUSEMAP_HEIGHT_MARGIN;

        addChild(_gridLayer);
    }

    private function onObjectAdded(event:FieldEvent):void
    {
        render();
    }

    private function onHeightMapChanged(event:FieldEvent):void
    {
        redrawHeightMapTile(event);
//		redrawGridTile(event);
        redrawFieldTile(event);
    }

    private function redrawGridTile(event:FieldEvent):void
    {
        var tileSprite:Sprite = new Sprite();
        var x:int = event.pos.x;
        var y:int = event.pos.y;

        for (var i:int = -1; i < 1; i++)
        {
            for (var j:int = -1; j < 1; j++)
            {
                drawGridTile(tileSprite, 0xFFFFFF, x + i, y + j, true, true);
            }
        }

        _grid.bitmapData.draw(tileSprite, new Matrix(1, 0, 0, 1, fieldMaxWidth / 2, Constants.MOUSEMAP_HEIGHT_MARGIN));
    }

    private function redrawFieldTile(event:FieldEvent):void
    {
        var x:int = event.pos.x;
        var y:int = event.pos.y;

        _field.bitmapData.lock();
        for (var i:int = -1; i < 1; i++)
        {
            for (var j:int = -1; j < 1; j++)
            {
                var tile:DisplayObject = getTileSprite(x + i, y + j);
                _field.bitmapData.draw(tile, new Matrix(1, 0, 0, 1, fieldMaxWidth / 2 + getScreenX(x + i, y + j),
                        Constants.MOUSEMAP_HEIGHT_MARGIN + getScreenY(x + i, y + j)));
            }
        }

        _field.bitmapData.unlock();
    }

    private function redrawHeightMapTile(event:FieldEvent):void
    {
        var mouseMapSprite:Sprite = new Sprite();
        var x:int = event.pos.x;
        var y:int = event.pos.y;

        for (var i:int = -1; i < 1; i++)
        {
            for (var j:int = -1; j < 1; j++)
            {
                var color:uint = getHeightTileColor(x + i, y + j);
                drawGridTile(mouseMapSprite, color, x + i, y + j);
            }
        }

        _heightMouseMap.bitmapData.draw(mouseMapSprite, new Matrix(1, 0, 0, 1, fieldMaxWidth / 2, Constants.MOUSEMAP_HEIGHT_MARGIN));
    }

    private function onClick(event:MouseEvent):void
    {
        if (_mouseMovedAfterDown) return;

        var pixel:uint = _heightMouseMap.bitmapData.getPixel(container.mouseX + fieldMaxWidth / 2, container.mouseY + Constants.MOUSEMAP_HEIGHT_MARGIN);

        if (_heightMouseColors[pixel])
        {
            dispatchEvent(new FieldEvent(FieldEvent.MOUSE_CLICK, new IntPnt(_heightMouseColors[pixel].x, _heightMouseColors[pixel].y), event));
        }
    }

    private function onMouseDown(event:MouseEvent):void
    {
        _mouseMovedAfterDown = null;
    }

    private function onMouseMove(event:MouseEvent):void
    {
        _mouseMovedAfterDown = event;
        _mouseMovedAfterFrame = event;
    }

    private function onEnterFrame(event:Event):void
    {
        render();

        if (_mouseMovedAfterFrame)
        {
            var pixel:uint = _heightMouseMap.bitmapData.getPixel(container.mouseX + fieldMaxWidth / 2, container.mouseY + Constants.MOUSEMAP_HEIGHT_MARGIN);

            if (_heightMouseColors[pixel])
            {
                dispatchEvent(new FieldEvent(FieldEvent.MOUSE_MOVE, new IntPnt(_heightMouseColors[pixel].x, _heightMouseColors[pixel].y), _mouseMovedAfterFrame));
                _selectedSellOfGrid.graphics.clear();
                drawSelectTile(_selectedSellOfGrid, 0x008800, _heightMouseColors[pixel].x, _heightMouseColors[pixel].y);
            }
            else
            {
                dispatchEvent(new FieldEvent(FieldEvent.MOUSE_MOVE, new IntPnt(-1, -1), _mouseMovedAfterFrame));
            }

            _mouseMovedAfterFrame = null;
        }
    }

    private function redrawHeightGrid():void
    {
        var gridSprite:Sprite = new Sprite();

        for (var i:int = 0; i < Constants.MAX_FIELD_SIZE; i++)
        {
            for (var j:int = 0; j < Constants.MAX_FIELD_SIZE; j++)
            {
                drawGridTile(gridSprite, 0xFFFFFF, i, j, true, true);
            }
        }

        _grid.bitmapData.lock();
        _grid.bitmapData.draw(gridSprite, new Matrix(1, 0, 0, 1, fieldMaxWidth / 2, Constants.MOUSEMAP_HEIGHT_MARGIN));
        for (j = 0; j < _grid.height; j++)
        {
            for (i = 0; i < _grid.width; i++)
            {
                if (_grid.bitmapData.getPixel(i, j) == 0xFFFFFF)
                {
                    _grid.bitmapData.setPixel32(i, j, 0x00FFFFFF);
                }
            }
        }
        _grid.bitmapData.unlock();
    }

    private function getHeightTileColor(x:int, y:int):uint
    {
        return _heightMouseHash[x][y];
    }

    private function get fieldMaxWidth():Number
    {
        return 4 / Math.sqrt(5) * Constants.TILE_SIZE * Math.sqrt(2) * (Constants.MAX_FIELD_SIZE - 1);
    }

    private function get fieldMaxHeight():Number
    {
        return fieldMaxWidth / 2 + Constants.MOUSEMAP_HEIGHT_MARGIN;
    }

    private function zz(x_pos:int, y_pos:int):Number
    {
        return _model.getHeight(x_pos, y_pos);
    }

    private function redrawMouseTileMap():void
    {
        var colorCounter:uint = 1;
        var mouseMapSprite:Sprite = new Sprite();


        for (var i:int = 0; i < Constants.MAX_FIELD_SIZE; i++)
        {
            for (var j:int = 0; j < Constants.MAX_FIELD_SIZE; j++)
            {
                _heightMouseColors[colorCounter] = {x: i, y: j};
                drawGridTile(mouseMapSprite, colorCounter, i, j);
                colorCounter += 20;
            }
        }

        _heightMouseMap.bitmapData.draw(mouseMapSprite, new Matrix(1, 0, 0, 1, fieldMaxWidth / 2, Constants.MOUSEMAP_HEIGHT_MARGIN));
        createMouseTileHash(_heightMouseColors);
    }

    private function createMouseTileHash(heightMouseColors:Object):void
    {
        _heightMouseHash = [];
        for (var i:int = 0; i < Constants.MAX_FIELD_SIZE; i++)
        {
            _heightMouseHash.push([]);
            (_heightMouseHash[i] as Array).length = Constants.MAX_FIELD_SIZE;
        }

        for (var key:String in heightMouseColors)
        {
            var color:uint = uint(key);
            var pnt:Object = heightMouseColors[key];
            _heightMouseHash[pnt.x][pnt.y] = color;
        }
    }

    private function drawGridTile(map:Sprite, color:uint, x:int, y:int, fill:Boolean = true, border:Boolean = false):void
    {
        if (border)
        {
            map.graphics.lineStyle(0, 0xCCCCCC);
        }
        else
        {
            map.graphics.lineStyle(0, 0, 0);
        }

        if (fill)
        {
            map.graphics.beginFill(color);
        }
        map.graphics.moveTo(getScreenX(x, y), getScreenY(x, y));

        map.graphics.lineTo(getScreenX(x + 1, y), getScreenY(x + 1, y));
        map.graphics.lineTo(getScreenX(x + 1, y + 1), getScreenY(x + 1, y + 1));
        map.graphics.lineTo(getScreenX(x, y + 1), getScreenY(x, y + 1));
        map.graphics.lineTo(getScreenX(x, y), getScreenY(x, y));
        if (fill)
        {
            map.graphics.endFill();
        }

        var posText:TextField = new TextField();
        posText.text = x + "," + y;
        posText.x = getScreenX(x, y);
        posText.y = getScreenY(x, y);
        map.addChild(posText);
    }


    private function drawSelectTile(map:Sprite, color:uint, x:int, y:int, fill:Boolean = true, border:Boolean = false):void
    {
        if (border)
        {
            map.graphics.lineStyle(0, 0xCCCCCC);
        }
        else
        {
            map.graphics.lineStyle(0, 0, 0);
        }

        if (fill)
        {
            map.graphics.beginFill(color);
        }
        map.graphics.moveTo(getScreenX(x, y), getScreenY(x, y));

        map.graphics.lineTo(getScreenX(x + 1, y), getScreenY(x + 1, y));
        map.graphics.lineTo(getScreenX(x + 1, y + 1), getScreenY(x + 1, y + 1));
        map.graphics.lineTo(getScreenX(x, y + 1), getScreenY(x, y + 1));
        map.graphics.lineTo(getScreenX(x, y), getScreenY(x, y));
        if (fill)
        {
            map.graphics.endFill();
        }
    }

    private function getScreenX(x:int, y:int):Number
    {
        return IsoMath.isoToScreen(new Pt(x * Constants.TILE_SIZE, y * Constants.TILE_SIZE, zz(x, y) * Constants.TILE_HEIGHT)).x;
    }

    private function getScreenY(x:int, y:int):Number
    {
        return IsoMath.isoToScreen(new Pt(x * Constants.TILE_SIZE, y * Constants.TILE_SIZE, zz(x, y) * Constants.TILE_HEIGHT)).y;
    }

    override public function addChild(child:INode):void
    {
        super.addChild(child);
        render();
    }

    public function update(event:Event = null):void
    {
//        redrawHeightGrid();
        redrawMouseTileMap();
        redrawField();
        render();
    }

    private function redrawField():void
    {

        _field.bitmapData.lock();
        for (var i:int = 0; i < Constants.MAX_FIELD_SIZE - 1; i++)
        {
            for (var j:int = 0; j < Constants.MAX_FIELD_SIZE - 1; j++)
            {
                var tile:DisplayObject = getTileSprite(i, j);
                _field.bitmapData.draw(tile, new Matrix(1, 0, 0, 1, fieldMaxWidth / 2 + getScreenX(i, j), Constants.MOUSEMAP_HEIGHT_MARGIN + getScreenY(i, j)));
            }
        }

        _field.bitmapData.unlock();
    }

    private function getTileSprite(x:int, y:int):DisplayObject
    {
        return TileSpritesCache.getNewSprite(zz(x, y), zz(x + 1, y), zz(x + 1, y + 1), zz(x, y + 1));
    }

}
}
