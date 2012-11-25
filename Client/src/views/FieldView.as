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

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;

import models.IFieldModel;

import utils.IntPnt;

public class FieldView extends IsoScene
{
    private var _model:IFieldModel;

    private var _heightMouseMap:Bitmap = new Bitmap(new BitmapData(fieldMaxWidth, fieldMaxHeight + Constants.MOUSEMAP_HEIGHT_MARGIN));
    private var _heightMouseHash:Object = {};

    private var _parentView:IsoView;
    private var _cellOfGrid:Sprite = new Sprite();
    private var _grid:Bitmap = new Bitmap(new BitmapData(fieldMaxWidth, fieldMaxHeight + Constants.MOUSEMAP_HEIGHT_MARGIN));
    private var _gridLayer:IsoSprite = new IsoSprite();

    public function FieldView(model:IFieldModel, parentView:IsoView)
    {
        _model = model;
        _parentView = parentView;
        _parentView.mouseChildren = false;
        _parentView.mouseEnabled = false;

        _model.addEventListener(FieldEvent.HEIGHTMAP_CHANGED, onHeightMapChanged);
        _model.addEventListener(FieldEvent.OBJECT_ADDED, onObjectAdded);
        _parentView.addEventListener(Event.ENTER_FRAME, onEnterFrame);
        _parentView.stage.addEventListener(MouseEvent.CLICK, onClick);

        _gridLayer.sprites = [_grid, _cellOfGrid];
        _grid.x = -fieldMaxWidth / 2;
        _grid.y = -Constants.MOUSEMAP_HEIGHT_MARGIN;
        addChild(_gridLayer);
    }

    private function onObjectAdded(event:FieldEvent):void
    {
        render();
    }

    private function onHeightMapChanged(event:FieldEvent):void
    {
        redrawHeightMapTile(event);
        redrawGridTile(event);
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
                drawTile(tileSprite, 0xCCCCCC, x + i, y + j, true, true);
            }
        }

        _grid.bitmapData.draw(tileSprite, new Matrix(1, 0, 0, 1, fieldMaxWidth / 2, Constants.MOUSEMAP_HEIGHT_MARGIN));
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
                var color:String = getHeightTileColor(x + i, y + j);
                drawTile(mouseMapSprite, uint(color), x + i, y + j);
            }
        }

        _heightMouseMap.bitmapData.draw(mouseMapSprite, new Matrix(1, 0, 0, 1, fieldMaxWidth / 2, Constants.MOUSEMAP_HEIGHT_MARGIN));
    }

    private function onClick(event:MouseEvent):void
    {
        var pixel:uint = _heightMouseMap.bitmapData.getPixel(container.mouseX + fieldMaxWidth / 2, container.mouseY + Constants.MOUSEMAP_HEIGHT_MARGIN);

        if (_heightMouseHash[pixel])
        {
            dispatchEvent(new FieldEvent(FieldEvent.MOUSE_CLICK, new IntPnt(_heightMouseHash[pixel].x, _heightMouseHash[pixel].y), event));
        }
    }

    private function onEnterFrame(event:Event):void
    {
        render();

        var pixel:uint = _heightMouseMap.bitmapData.getPixel(container.mouseX + fieldMaxWidth / 2, container.mouseY + Constants.MOUSEMAP_HEIGHT_MARGIN);

        if (_heightMouseHash[pixel])
        {
            dispatchEvent(new FieldEvent(FieldEvent.MOUSE_MOVE, new IntPnt(_heightMouseHash[pixel].x, _heightMouseHash[pixel].y), event));
            _cellOfGrid.graphics.clear();
            drawTile(_cellOfGrid, 0x008800, _heightMouseHash[pixel].x, _heightMouseHash[pixel].y);
        }
    }

    private function redrawHeightGrid():void
    {
        var gridSprite:Sprite = new Sprite();

        for (var i:int = 0; i < Constants.MAX_FIELD_SIZE; i++)
        {
            for (var j:int = 0; j < Constants.MAX_FIELD_SIZE; j++)
            {
                drawTile(gridSprite, 0xEEEEEE, i, j, true, true);
            }
        }

        _grid.bitmapData.draw(gridSprite, new Matrix(1, 0, 0, 1, fieldMaxWidth / 2, Constants.MOUSEMAP_HEIGHT_MARGIN));
    }

    private function getHeightTileColor(x:int, y:int):String //TODO: Build x,y to tile map //вместо перебора
    {
        for (var color:String in _heightMouseHash)
        {
            if (_heightMouseHash[color].x == x && _heightMouseHash[color].y == y)
                return color;
        }
        return "";
    }

    private function get fieldMaxWidth():Number
    {
        return 4 / Math.sqrt(5) * Constants.TILE_SIZE * Math.sqrt(2) * (Constants.MAX_FIELD_SIZE - 1);
    }

    private function get fieldMaxHeight():Number
    {
        return fieldMaxWidth / 2 + Constants.MOUSEMAP_HEIGHT_MARGIN;
    }

    private function zz(x_height:int, y_height:int):Number
    {
        return _model.getHeight(x_height, y_height);
    }

    private function redrawTileMap():void
    {
        var colorCounter:uint = 1;
        var mouseMapSprite:Sprite = new Sprite();

        for (var i:int = 0; i < Constants.MAX_FIELD_SIZE; i++)
        {
            for (var j:int = 0; j < Constants.MAX_FIELD_SIZE; j++)
            {
                _heightMouseHash[colorCounter] = {x:i, y:j};
                drawTile(mouseMapSprite, colorCounter, i, j);
                colorCounter += 20;
            }
        }

        _heightMouseMap.bitmapData.draw(mouseMapSprite, new Matrix(1, 0, 0, 1, fieldMaxWidth / 2, Constants.MOUSEMAP_HEIGHT_MARGIN));
    }

    private function drawTile(map:Sprite, color:uint, x:int, y:int, fill:Boolean = true, border:Boolean = false):void
    {
        if (border) map.graphics.lineStyle(.1);
        else map.graphics.lineStyle(0);

        if (fill) map.graphics.beginFill(color);
        map.graphics.moveTo(getX(x, y), getY(x, y));

        map.graphics.lineTo(getX(x + 1, y), getY(x + 1, y));
        map.graphics.lineTo(getX(x + 1, y + 1), getY(x + 1, y + 1));
        map.graphics.lineTo(getX(x, y + 1), getY(x, y + 1));
        map.graphics.lineTo(getX(x, y), getY(x, y));
        if (fill) map.graphics.endFill();
    }

    private function getX(x:int, y:int):Number
    {
        return IsoMath.isoToScreen(new Pt(x * Constants.TILE_SIZE, y * Constants.TILE_SIZE, zz(x, y) * Constants.TILE_HEIGHT)).x;
    }

    private function getY(x:int, y:int):Number
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
        redrawHeightGrid();
        redrawTileMap();
        render();
    }
}
}
