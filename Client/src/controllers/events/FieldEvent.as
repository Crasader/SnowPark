/**
 * Author: JuzTosS
 * Date: 15.11.12
 */
package controllers.events
{
import flash.events.Event;

import utils.IntPnt;

public class FieldEvent extends Event
{
    public static const MOUSE_CLICK:String = "SnowFieldMouseClick";
    public static const MOUSE_MOVE:String = "SnowFieldMouseMove";
    public static const HEIGHTMAP_CHANGED:String = "SnowHeightMapChanged";

    private var _targetEvent:Event;
    private var _pos:IntPnt;

    public function FieldEvent(type:String, pos:IntPnt = null, targetEvent:Event = null)
    {
        super(type);
        _pos = pos;
        _targetEvent = targetEvent
    }

    public function get pos():IntPnt
    {
        return _pos;
    }

    override public function clone():Event
    {
        return new FieldEvent(type, _pos, _targetEvent);
    }

    public function get targetEvent():Event
    {
        return _targetEvent;
    }
}
}
