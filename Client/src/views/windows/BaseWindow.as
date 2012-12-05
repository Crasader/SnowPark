/**
 * Author: JuzTosS
 * Date: 29.11.12
 */
package views.windows
{
import com.junkbyte.console.Cc;

import config.Constants;

import events.UserViewEvent;

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import net.loaders.MovieLoader;

import utils.ButtonUtil;

public class BaseWindow extends Sprite implements IWindow
{
    private var _visual:MovieLoader;

    public function BaseWindow()
    {
        addEventListener(MouseEvent.MOUSE_DOWN, stopEvent);
        addEventListener(MouseEvent.CLICK, stopEvent);
        addEventListener(MouseEvent.MOUSE_UP, stopEvent);
        addEventListener(MouseEvent.MOUSE_MOVE, stopEvent);
        addEventListener(MouseEvent.MOUSE_WHEEL, stopEvent);
    }

    private function stopEvent(e:MouseEvent):void
    {
        e.stopPropagation();
    }

    public function loadVisual():void
    {
        _visual = new MovieLoader(Constants.GRAPHICS_PATH + resourceName(), resourceClass());
        _visual.addEventListener(MovieLoader.MOVIE_LOADED, onLoaded);
        _visual.addEventListener(MovieLoader.ERROR_LOAD_MOVIE, onErrorLoad);
        _visual.startLoad();
    }

    protected function resourceClass():String
    {
        return null;
    }

    protected function resourceName():String
    {
        return null;
    }

    protected function get visual():MovieLoader
    {
        return _visual;
    }

    protected function onErrorLoad(event:Event):void
    {

    }

    protected function onLoaded(event:Event):void
    {
        correctPosition();
    }

    private function correctPosition():void
    {
        visual.x = Constants.STAGE_WIDTH / 2 - visual.width / 2;
        visual.y = Constants.STAGE_HEIGHT / 2 - visual.height / 2;
    }

    protected function getChildByNameAs(name:String, type:Class, parent:Sprite = null):DisplayObject
    {
        if (!parent)
        {
            parent = visual.content as Sprite;
        }
        if (!parent)
        {
            Cc.error("Invalid container for " + name + " and " + type);
            return null;
        }

        var child:DisplayObject = parent.getChildByName(name);
        if (!(child is type))
        {
            Cc.error("Can't find DO: " + name + " in " + parent);
            return null;
        }

        if (!(child is type))
        {
            Cc.error("Mismatch types, for: " + name + "obj: " + child + " and " + type + " in " + parent);
            return null;
        }

        return child;
    }

    protected function createCloseButton():void
    {
        var buttonClose:MovieClip = getChildByNameAs("buttonClose", MovieClip) as MovieClip;
        if (buttonClose)
        {
            ButtonUtil.setButton(buttonClose, close);
        }
    }

    private function close(e:Event = null):void
    {
        dispatchEvent(new UserViewEvent(UserViewEvent.CLOSE_WND, true));
    }
}
}
