/**
 * Author: JuzTosS
 * Date: 18.11.12
 */
package objects.components
{
import as3isolib.core.IsoDisplayObject;

import flash.events.IEventDispatcher;

public interface IViewComponent extends IEventDispatcher
{
    function get sprites():Array

    function updatePos(view:IsoDisplayObject, dt:Number):void
}
}
