/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 23.03.12
 * Time: 20:13
 * To change this template use File | Settings | File Templates.
 */
package basemvc.compose
{
import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.events.EventDispatcher;

public class ComponentObject extends EventDispatcher
{
    internal var _parent:CompositeObject;
    internal var _child_index:int;

    public static var _core:CompositeObject;

    public function ComponentObject()
    {
    }

    public function add(c:ComponentObject):void
    {
        throw new IllegalOperationError("add operation not supported");
    }

    public function remove(c:ComponentObject):void
    {
        throw new IllegalOperationError("remove operation not supported");
    }

    public function getChild(n:int):ComponentObject
    {
        throw new IllegalOperationError("getChild operation not supported");

        return null;
    }

    public function update(event:Event = null):void
    {
        throw new IllegalOperationError("method must be reimplemented");
    }

    override public function dispatchEvent(event:Event):Boolean
    {
        var result:Boolean = super.dispatchEvent(event);

        if(event.bubbles && _parent)
            _parent.dispatchEvent(event);

        return result;
    }

    public function get child_index():int
    {
        return _child_index;
    }

    public function get parent():CompositeObject
    {
        return _parent;
    }

    internal function set_parent(value:CompositeObject):void
    {
        dispatchEvent(new Event(Event.ADDED));
    }
}
}
