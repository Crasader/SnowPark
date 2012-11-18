/**
 * Author: JuzTosS
 * Date: 17.11.12
 */
package objects.components
{
import as3isolib.display.IsoSprite;

import flash.events.EventDispatcher;

import net.loaders.MovieLoader;

import objects.ObjectModel;

public class BaseComponent extends EventDispatcher implements IViewComponent
{
    private var _model:ObjectModel;
    private var _view:IsoSprite;
    private var _loader:MovieLoader;

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

    public function updatePos(dt:Number):void
    {
    }

    public function initView(view:IsoSprite, loader:MovieLoader):void
    {
        _view = view;
        _loader = loader;
    }

    public function get view():IsoSprite
    {
        return _view;
    }

    public function get loader():MovieLoader
    {
        return _loader;
    }
}
}
