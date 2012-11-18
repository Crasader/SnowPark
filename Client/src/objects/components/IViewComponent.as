/**
 * Author: JuzTosS
 * Date: 18.11.12
 */
package objects.components
{
import as3isolib.display.IsoSprite;

import flash.display.Sprite;
import flash.events.IEventDispatcher;

public interface IViewComponent extends IEventDispatcher
{
    function get sprites():Array

    function updatePos(view:IsoSprite, mainSprite:Sprite, dt:Number):void
}
}
