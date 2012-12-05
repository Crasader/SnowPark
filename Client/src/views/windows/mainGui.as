/**
 * Author: JuzTosS
 * Date: 29.11.12
 */
package views.windows
{
import config.Constants;

import events.UserEvent;
import events.UserViewEvent;

import flash.events.Event;
import flash.events.MouseEvent;

import net.loaders.MovieLoader;

import utils.ButtonUtil;

public class MainGui extends BaseWindow
{
    private var _visual:MovieLoader;

    public function MainGui()
    {
        _visual = new MovieLoader(Constants.GRAPHICS_PATH + "gui/gui.swf", "MainGui");
        _visual.addEventListener(MovieLoader.MOVIE_LOADED, onGUILoaded);
        _visual.addEventListener(MovieLoader.ERROR_LOAD_MOVIE, onErrorLoadGUI);
        _visual.startLoad();
    }

    private function onErrorLoadGUI(event:Event):void
    {

    }

    private function onGUILoaded(event:Event):void
    {
        addChild(_visual);
        init();
    }

    private function init():void
    {
        ButtonUtil.setButton(_visual.content["buttonBuild"], onBuildClick);
        ButtonUtil.setButton(_visual.content["buttonDestroy"], onDestroyClick);
        ButtonUtil.setButton(_visual.content["buttonCancel"], onCancelClick);
        ButtonUtil.setButton(_visual.content["buttonUp"], onUpClick);
        ButtonUtil.setButton(_visual.content["buttonDown"], onDownClick);
        ButtonUtil.setButton(_visual.content["buttonSettings"], onSettingsClick);
        ButtonUtil.setButton(_visual.content["buttonMoney"], onMoneyClick);
        ButtonUtil.setButton(_visual.content["buttonExp"], onExpClick);
        ButtonUtil.setButton(_visual.content["buttonReal"], onRealClick);
        ButtonUtil.setButton(_visual.content["buttonAllFriends"], onAllFriendsClick);
    }

    private function onDestroyClick(e:MouseEvent):void
    {
        dispatchEvent(new UserEvent(UserEvent.TOOL_DESTROY, true));
    }

    private function onCancelClick(e:MouseEvent):void
    {
        dispatchEvent(new UserEvent(UserEvent.CANCEL, true));
    }

    private function onBuildClick(e:MouseEvent):void
    {
        dispatchEvent(new UserViewEvent(UserViewEvent.SHOW_SHOP_WND, true));
    }

    private function onUpClick(e:MouseEvent):void
    {
        dispatchEvent(new UserEvent(UserEvent.TOOL_UP, true));
    }

    private function onDownClick(e:MouseEvent):void
    {
        dispatchEvent(new UserEvent(UserEvent.TOOL_DOWN, true));
    }

    private function onSettingsClick(e:MouseEvent):void
    {
        dispatchEvent(new UserViewEvent(UserViewEvent.SHOW_POPUP, true, {header:"Функция не поддерживается", content:"Не тыкайте куда попало!"}));
    }

    private function onMoneyClick(e:MouseEvent):void
    {
        dispatchEvent(new UserEvent(UserEvent.MONEY, true));
    }

    private function onExpClick(e:MouseEvent):void
    {
        dispatchEvent(new UserEvent(UserEvent.EXP, true));
    }

    private function onRealClick(e:MouseEvent):void
    {
        dispatchEvent(new UserEvent(UserEvent.REAL, true));
    }

    private function onAllFriendsClick(e:MouseEvent):void
    {
        dispatchEvent(new UserEvent(UserEvent.ALL_FRIENDS, true));
    }
}
}
