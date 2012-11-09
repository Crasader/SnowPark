/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 23.03.12
 * Time: 20:06
 * To change this template use File | Settings | File Templates.
 */
package basemvc.compose
{

import flash.events.Event;

public class CompositeObject extends ComponentObject
{
    private var _children:Array = [];

    public function CompositeObject()
    {
    }

    override public function add(c:ComponentObject):void
    {
        _children.push(c);
        c._parent = this;
        c._childIndex = _children.indexOf(c);

        c.dispatchEvent(new Event(Event.ADDED));
    }

    override public function update(event:Event = null):void
    {
        for each(var c:ComponentObject in _children)
        {
            c.update(event);
        }
    }

    override public function remove(c:ComponentObject):void
    {
        _children.splice(c, 1);
        c._parent = null;
        c._childIndex = undefined;
    }

    override public function getChild(n:int):ComponentObject
    {
        return _children[n];
    }

    public function get numChildren():int
    {
        return _children.length;
    }
}
}
