/**
 * Author: JuzTosS
 * Date: 17.11.12
 */
package events
{
import as3isolib.geom.Pt;

import flash.events.Event;

public class ObjectEvent extends Event
{
    public static const POSITION_UPDATED:String = "SnowPositionUpdated";

    private var _prevPos:Pt;
    private var _curPos:Pt;

    public function ObjectEvent(type:String, prevPos:Pt, curPos:Pt)
    {
        _prevPos = prevPos;
        _curPos = curPos;
        super(type);
    }

    override public function clone():Event
    {
        return new ObjectEvent(type, prevPos, curPos);
    }

    public function get prevPos():Pt
    {
        return _prevPos;
    }

    public function get curPos():Pt
    {
        return _curPos;
    }
}
}
