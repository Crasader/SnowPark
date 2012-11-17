/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 08.04.12
 * Time: 2:17
 * To change this template use File | Settings | File Templates.
 */
package models
{
import controllers.events.CoreEvent;
import controllers.events.FieldEvent;

import flash.events.Event;
import flash.events.EventDispatcher;

import objects.BaseSpaceObjectModel;

import utils.IntPnt;

public class FieldModel extends EventDispatcher implements IFieldModel
{
    private var _field:SnowParkField;
    private var _heightMap:Array;
    private var _allObjects:Vector.<BaseSpaceObjectModel> = new Vector.<BaseSpaceObjectModel>();

    public function FieldModel()
    {
        _field = new SnowParkField();
    }

    public function getField():SnowParkField
    {
        return _field;
    }

    public function placeObject(objModel:BaseSpaceObjectModel, pos:IntPnt):Boolean
    {
        objModel._x = pos.x;
        objModel._y = pos.y;
        objModel._z = _heightMap[pos.x][pos.y];

        if (!isPlaceFree(objModel))
            return false;

        fillFieldByObject(objModel);
        _allObjects.push(objModel);

        dispatchEvent(new FieldEvent(FieldEvent.OBJECT_ADDED, pos));
        return true;
    }

    private function fillFieldByObject(obj:BaseSpaceObjectModel):void
    {
        for (var x:int = obj._x; x < obj._x + obj._width; x++)
            for (var y:int = obj._y; y < obj._y + obj._length; y++)
            {
                _field.setBlock(new IntPnt(x, y), obj);
            }
    }

    private function isPlaceFree(obj:BaseSpaceObjectModel):Boolean
    {
        for (var x:int = obj._x; x < obj._x + obj._width; x++)
            for (var y:int = obj._y; y < obj._y + obj._length; y++)
            {
                if (isPosInvalid(new IntPnt(x, y))
                        || (_field.getBlock(new IntPnt(x, y)) != null))
                    return false;
            }

        return true;
    }

    public function isPosInvalid(pos:IntPnt):Boolean
    {
        return (pos.x >= _field.width || pos.y >= _field.height || pos.x < 0 || pos.y < 0);
    }

    public function clear():void
    {
        while (_allObjects.length != 0)
        {
            var objToDestroy:BaseSpaceObjectModel = _allObjects.pop();
            objToDestroy.destroy();
        }

        _field = new SnowParkField();

        dispatchEvent(new Event(Event.CHANGE));
    }

    public function get allObjects():Vector.<BaseSpaceObjectModel>
    {
        return _allObjects;
    }

    public function setHeight(x:int, y:int, height:int):Boolean
    {
        if (!isHeightValid(x, y, height)) return false;

        _heightMap[x][y] = height;
        dispatchEvent(new FieldEvent(FieldEvent.HEIGHTMAP_CHANGED, new IntPnt(x, y)));
        return true;
    }

    private function isHeightValid(x:int, y:int, height:int):Boolean
    {
        for (var i:int = -1; i < 2; i++)
        {
            for (var j:int = -1; j < 2; j++)
            {
                if (i == 0 && j == 0) continue;
                var diff:int = Math.abs(_heightMap[x + i][y + j] - height);
                if (diff > 1)
                    return false;
            }
        }

        return true;
    }

    public function set heightMap(value:Array):void
    {
        _heightMap = value;
        dispatchEvent(new Event(Event.CHANGE));
    }

    public function getHeight(x:int, y:int):int
    {
        if (!_heightMap) return 0;
        if (!_heightMap[x]) return 0;
        if (!_heightMap[x][y]) return 0;

        return _heightMap[x][y];
    }

    public function tick(event:CoreEvent):void
    {
        var dt:Number = Number(event.data);
        for each(var obj:BaseSpaceObjectModel in allObjects)
        {
            obj.tick(dt);
        }
    }

    public function onFrame(event:CoreEvent):void
    {
        var dt:Number = Number(event.data);
        for each(var obj:BaseSpaceObjectModel in allObjects)
        {
            obj.onFrame(dt);
        }
    }
}
}
