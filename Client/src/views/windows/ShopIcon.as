/**
 * Author: JuzTosS
 * Date: 02.12.12
 */
package views.windows
{
import config.Constants;

import events.UserEvent;
import events.UserViewEvent;

import flash.display.MovieClip;
import flash.events.Event;
import flash.text.TextField;

import net.loaders.MovieLoader;

import utils.ButtonUtil;

public class ShopIcon extends BaseWindow
{
    private var _id:String;

    public function ShopIcon(id:String)
    {
        _id = id;
        loadVisual();
    }

    override protected function onLoaded(event:Event):void
    {
        addChild(visual);
        init();
    }

    private function setBuyTool(event:Event):void
    {
        var e:UserEvent = new UserEvent(UserEvent.BUILD, true);
        e.data = _id;
        dispatchEvent(e);
        dispatchEvent(new UserViewEvent(UserViewEvent.CLOSE_WND, true));
    }

    private function init():void
    {
        ButtonUtil.setButton(button, setBuyTool);

        textName.text = Constants.CFG["objects"][_id]["descriptions"][Constants.CFG["i18n"]]["name"];
        textCostMoney.text = Constants.CFG["objects"][_id]["shop"]["priceMoney"];
        textCostReal.text = Constants.CFG["objects"][_id]["shop"]["priceReal"];

        var imagePath:String = Constants.GRAPHICS_PATH + Constants.CFG["objects"][_id]["view"]["shop"];
        var image:MovieLoader = new MovieLoader(imagePath);
        image.startLoad();
        visual.addChild(image);
    }

    override protected function resourceName():String
    {
        return "gui/shopWindow.swf";
    }

    override protected function resourceClass():String
    {
        return "ShopIconMovie";
    }

    private function get button():MovieClip
    {
        return getChildByNameAs("button", MovieClip) as MovieClip;
    }

    private function get anchor():MovieClip
    {
        return getChildByNameAs("anchor", MovieClip) as MovieClip;
    }

    private function get textCostReal():TextField
    {
        return getChildByNameAs("textCostReal", TextField) as TextField;
    }

    private function get textCostMoney():TextField
    {
        return getChildByNameAs("textCostMoney", TextField) as TextField;
    }

    private function get textName():TextField
    {
        return getChildByNameAs("textName", TextField) as TextField;
    }
}
}
