/**
 * Author: JuzTosS
 * Date: 29.11.12
 */
package views.windows
{
import com.junkbyte.console.Cc;

import config.Constants;

import flash.display.MovieClip;
import flash.events.Event;
import flash.text.TextField;

import utils.ButtonUtil;

public class ShopWindow extends BaseWindow
{

    private static const ICON_DIST:Number = 60;

    private static const DECOR:String = "decor";
    private static const KICKER:String = "kicker";
    private static const BUILD:String = "build";
    private var _state:String = DECOR;
    private var _tabsData:Object = {};

    public function ShopWindow()
    {
        initTabData();
        loadVisual();
    }

    private function initTabData():void
    {
        _tabsData[DECOR] = [];
        _tabsData[KICKER] = [];
        _tabsData[BUILD] = [];
        setItems();
    }

    override protected function resourceName():String
    {
        return "gui/shopWindow.swf";
    }

    override protected function onLoaded(event:Event):void
    {
        super.onLoaded(event);

        init();
        addChild(visual);
    }

    private function init():void
    {
        createCloseButton();

        ButtonUtil.setButton(buttonDecor, decorButtonAction);
        ButtonUtil.setButton(buttonKicker, kickerButtonAction);
        ButtonUtil.setButton(buttonBuild, buildButtonAction);

        update();
    }

    private function decorButtonAction(e:Event):void
    {
        setNewState(DECOR);
    }

    private function kickerButtonAction(e:Event):void
    {
        setNewState(KICKER);
    }

    private function buildButtonAction(e:Event):void
    {
        setNewState(BUILD);
    }

    private function setNewState(newState:String):void
    {
        if (_state != newState)
        {
            _state = newState;
            update();
        }
    }

    private function update():void
    {
        updateTitle();
        updateItems();
    }

    private function updateItems():void
    {
        while (anchor.numChildren)
            anchor.removeChildAt(0);

        var nextX:int = 0;
        for each(var id:String in _tabsData[_state])
        {
            var icon:ShopIcon = new ShopIcon(id);
            icon.x = nextX;
            anchor.addChild(icon);
            nextX += ICON_DIST;
        }
    }

    private function updateTitle():void
    {
        if (_state == DECOR)
        {
            titleText.text = "decor";
        }
        else if (_state == KICKER)
        {
            titleText.text = "kicker";
        }
        else if (_state == BUILD)
        {
            titleText.text = "build";
        }
    }

    private function setItems():void
    {
        for (var id:String in Constants.CFG["objects"])
        {
            var obj:Object = Constants.CFG["objects"][id];

            if (obj && obj["shop"] && obj["shop"]["show"])
            {
                setObjectToTab(id, obj["shop"]["tab"]);
            }
        }

    }

    private function setObjectToTab(id:String, tabName:String):void
    {
        var tabData:Array = _tabsData[tabName];
        if (tabData == null)
        {
            Cc.warn("Can't find tab with name: " + tabName);
            return;
        }

        tabData.push(id);
    }

    private function get titleText():TextField
    {
        return getChildByNameAs("textTitle", TextField) as TextField;
    }

    private function get buttonDecor():MovieClip
    {
        return getChildByNameAs("buttonDecor", MovieClip) as MovieClip;
    }

    private function get buttonKicker():MovieClip
    {
        return getChildByNameAs("buttonKicker", MovieClip) as MovieClip;
    }

    private function get buttonBuild():MovieClip
    {
        return getChildByNameAs("buttonBuilding", MovieClip) as MovieClip;
    }

    private function get anchor():MovieClip
    {
        return getChildByNameAs("anchor", MovieClip) as MovieClip;
    }
}
}
