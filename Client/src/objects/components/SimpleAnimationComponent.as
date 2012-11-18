/**
 * Author: JuzTosS
 * Date: 17.11.12
 */
package objects.components
{
import as3isolib.display.IsoSprite;

import flash.display.MovieClip;
import flash.events.Event;

import net.loaders.MovieLoader;

import objects.ObjectModel;

public class SimpleAnimationComponent extends BaseComponent
{
    private static const DEFAULT_FPS:int = 30;

    private var _mainMC:MovieClip;
    private var _deltaTime:int = 1000 / DEFAULT_FPS;

    private var _lastOnFrameTime:Number = 0;

    public function SimpleAnimationComponent(m:ObjectModel)
    {
        super(m);
    }

    override public function initView(view:IsoSprite, loader:MovieLoader):void
    {
        super.initView(view, loader);
        loader.addEventListener(MovieLoader.MOVIE_LOADED, onMovieLoaded);
    }

    private function onMovieLoaded(event:Event):void
    {
        _mainMC = loader.content as MovieClip;
    }

    override public function onFrame(dt:Number):void
    {
        if (!_mainMC) return;

        if (_lastOnFrameTime + dt < _deltaTime)
        {
            _lastOnFrameTime += dt;
            return;
        }

        _lastOnFrameTime += dt;
        _lastOnFrameTime -= _deltaTime;

        if (_mainMC.currentFrame >= _mainMC.totalFrames)
            _mainMC.gotoAndStop(1);
        else
            _mainMC.nextFrame();
    }

    public static function get name():String
    {
        return "simpleAnimation";
    }

    override public function loadConfig(cfg:Object):void
    {
        if (cfg.fps)
            _deltaTime = 1000 / cfg.fps;
    }
}
}
