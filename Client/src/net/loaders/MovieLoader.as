/**
 * Author: JuzTosS
 * Date: 06.11.12
 */
package net.loaders
{
import br.com.stimuli.loading.BulkLoader;

import com.junkbyte.console.Cc;

import config.Constants;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.HTTPStatusEvent;

public class MovieLoader extends Sprite
{
    public static const MOVIE_LOADED:String = "snow_movie_loaded";
    public static const ERROR_LOAD_MOVIE:String = "snow_error_load_movie";

    private static const DEFAULT_MOVIE_CLASS_NAME:String = "External";

    private static var _loader:BulkLoader = new BulkLoader("snowMovieLoader");

    private var _path:String;
    private var _className:String;
    private var _loaderImage:Sprite = new LoaderImage();

    private var _content:DisplayObject;

    public function MovieLoader(path:String, className:String = null)
    {
        addChild(_loaderImage);

        _className = className;
        _path = path + Constants.SESSION_PARAM;

        _loader.add(_path);
        _loader.get(_path).addEventListener(BulkLoader.COMPLETE, onAllLoaded);
        _loader.get(_path).addEventListener(BulkLoader.ERROR, onErrorLoad);
        _loader.get(_path).addEventListener(BulkLoader.HTTP_STATUS, onHttpStatus);

    }

    private function onHttpStatus(event:HTTPStatusEvent):void
    {
        if (event.status != 200)//HTTP OK
        {
            Cc.error("can't load resource (HTTP: " + event.status + ") " + _path + " " + _className);
            dispatchEvent(new Event(ERROR_LOAD_MOVIE));
        }
    }

    private function onErrorLoad(event:Event):void
    {
        Cc.error("can't load resource " + _path + " " + _className);
        dispatchEvent(new Event(ERROR_LOAD_MOVIE));
    }

    private function onAllLoaded(event:Event = null):void
    {
        if (_content)
        {
            return;
        }

        var className:String = _className || DEFAULT_MOVIE_CLASS_NAME;
        try
        {
            var contentClass:Class = _loader.getDisplayObjectLoader(_path).contentLoaderInfo.applicationDomain.getDefinition(className) as Class;
        } catch (e:Error)
        {
            Cc.log(e.message);
            Cc.error("Can't find class with name \"" + className + "\", path = " + "\"" + _path + "\"");
            return;
        }
        var content:Sprite = new contentClass();
        if (!content)
        {
            Cc.error("Content isn't Sprite instance, path = " + "\"" + _path + "\"");
            return;
        }

        if (contains(_loaderImage))
        {
            removeChild(_loaderImage);
        }
        addChild(content);
        _content = content;

        dispatchEvent(new Event(MOVIE_LOADED));
    }

    public function startLoad():void
    {
        if (_loader.get(_path) && _loader.get(_path).isLoaded)
            onAllLoaded();
        else
            _loader.start();
    }

    public function get content():DisplayObject
    {
        return _content;
    }
}
}
