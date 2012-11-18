/**
 * Author: JuzTosS
 * Date: 17.11.12
 */
package objects.components
{
import as3isolib.display.IsoSprite;

import flash.display.Sprite;
import flash.events.EventDispatcher;

import objects.ObjectModel;

public class BaseComponent extends EventDispatcher implements IViewComponent
{
    private var _model:ObjectModel;

    public function BaseComponent(m:ObjectModel)
    {
        _model = m;
    }

    public function tick(dt:Number):void
    {
    }

    public function onFrame(dt:Number):void
    {
    }

    public function loadConfig(cfg:Object):void
    {
    }

    protected function get model():ObjectModel
    {
        return _model;
    }

    public function get sprites():Array
    {
        return [];
    }

    public function updatePos(view:IsoSprite, mainSprite:Sprite, dt:Number):void
    {
    }
}
}
