/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 08.04.12
 * Time: 2:17
 * To change this template use File | Settings | File Templates.
 */
package models
{
import flash.events.Event;
import flash.events.EventDispatcher;

import park.BaseSpaceObjectModel;

import utils.IntPnt;

public class FieldModel extends EventDispatcher
{
    private var _field:SnowParkField;
    private var _allObjects:Vector.<BaseSpaceObjectModel> = new Vector.<BaseSpaceObjectModel>();

    private static var _instanse:FieldModel;

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

        if (!isPlaceFree(objModel))
            return false;

        fillFieldByObject(objModel);
        _allObjects.push(objModel);

        dispatchEvent(new Event(Event.CHANGE));
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

    public static function get instanse():FieldModel
    {
        if (_instanse == null)
            _instanse = new FieldModel();
        return _instanse;
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
}
}
