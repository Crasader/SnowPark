/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 14.04.12
 * Time: 21:14
 * To change this template use File | Settings | File Templates.
 */
package objects
{
import as3isolib.display.IsoSprite;

import com.junkbyte.console.Cc;

import config.Constants;

import events.ObjectEvent;

import flash.events.Event;

import net.loaders.MovieLoader;

import objects.components.IViewComponent;

public class ObjectView extends IsoSprite
{
    protected var _model:IObjectModel;

    private var _visual:MovieLoader;

    private var _lastUpdateTime:Number = 0;

    public function ObjectView(model:IObjectModel)
    {
        _model = model;
        _model.addEventListener(ObjectEvent.POSITION_UPDATED, updatePos);

        addEventListener(Event.ADDED_TO_STAGE, onStage);

        _visual = new MovieLoader(Constants.GRAPHICS_PATH + _model.cfgView["field"]);
        _visual.addEventListener(MovieLoader.MOVIE_LOADED, onMovieLoaded);
        _visual.addEventListener(MovieLoader.ERROR_LOAD_MOVIE, onErrorLoadMovie);
        _visual.mouseChildren = false;
        _visual.mouseEnabled = false;

        sprites = [_visual];

        for each(var component:IViewComponent in _model.components)
        {
            sprites = sprites.concat(component.sprites);
        }

    }

    private function updatePos(event:ObjectEvent):void
    {
        if (_lastUpdateTime == 0)
        {
            _lastUpdateTime = new Date().time;
            x = Constants.TILE_SIZE * _model.x;
            y = Constants.TILE_SIZE * _model.y;
            z = Constants.TILE_HEIGHT * _model.z;
            return;
        }

        var now:Number = new Date().time;
        var dt:Number = (now - _lastUpdateTime) / 1000;
        _lastUpdateTime = now;

        for each (var component:IViewComponent in _model.components)
            component.updatePos(this, _visual, dt);
    }

    private function onErrorLoadMovie(event:Event):void
    {
        Cc.error("Error load movie for object " + _model.classId + ", path = " + "\"" + _model.cfgView["field"] + "\"");
    }

    private function onMovieLoaded(event:Event):void
    {

    }

    private function onStage(event:Event):void
    {
        _visual.startLoad();
    }
}
}
