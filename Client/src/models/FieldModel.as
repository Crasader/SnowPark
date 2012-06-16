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

    private static var _instanse:FieldModel;

    public function FieldModel()
    {
        _field = new SnowParkField();
    }

    public function getField():SnowParkField
    {
        return _field;
    }

    public function placeObject(obj_model:BaseSpaceObjectModel, pos:IntPnt):Boolean
    {
        obj_model._x = pos.x;
        obj_model._y = pos.y;
        
        if(!is_place_free(obj_model))
            return false;
        
        fill_field_by_object(obj_model);
        
        dispatchEvent(new Event(Event.CHANGE));
        return true;
    }

    private function fill_field_by_object(obj:BaseSpaceObjectModel):void
    {
        for(var x:int = obj._x; x < obj._x + obj._width; x++)
            for(var y:int = obj._y; y < obj._y + obj._length; y++)
            {
                _field.setBlock(new IntPnt(x, y), obj);
            }
    }

    private function is_place_free(obj:BaseSpaceObjectModel):Boolean
    {
        for(var x:int = obj._x; x < obj._x + obj._width; x++)
            for(var y:int = obj._y; y < obj._y + obj._length; y++)
            {
                if(is_pos_invalid(new IntPnt(x, y))
                    || (_field.getBlock(new IntPnt(x, y)) != null))
                    return false;
            }

        return true;
    }

    public static function get instanse():FieldModel
    {
        if(_instanse == null)
            _instanse = new FieldModel();
        return _instanse;
    }

    public function is_pos_invalid(pos:IntPnt):Boolean
    {
        return (pos.x >= _field.width || pos.y >= _field.height || pos.x < 0 || pos.y < 0);
    }
}
}
