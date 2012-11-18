/**
 * Author: JuzTosS
 * Date: 18.11.12
 */
package objects.components
{
import as3isolib.display.IsoSprite;

import flash.events.IEventDispatcher;

import net.loaders.MovieLoader;

public interface IViewComponent extends IEventDispatcher
{
    function get sprites():Array

    function updatePos(dt:Number):void

    function initView(view:IsoSprite, loader:MovieLoader):void

    function get loader():MovieLoader;

    function get view():IsoSprite;
}
}
