/**
 * Author: JuzTosS
 * Date: 11.06.12
 */
package views
{

import config.Constants;

import events.UserEvent;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import models.IBindableModel;

import net.loaders.MovieLoader;

import utils.ButtonUtil;

public class UserView extends Sprite
{
    private var _mainGUI:MovieLoader;

    public function UserView(model:IBindableModel)
    {
        _mainGUI = new MovieLoader(Constants.GRAPHICS_PATH + "gui/gui.swf", "MainGui");
        _mainGUI.addEventListener(MovieLoader.MOVIE_LOADED, onGUILoaded);
        _mainGUI.addEventListener(MovieLoader.ERROR_LOAD_MOVIE, onErrorLoadGUI);
        addChild(_mainGUI);
        _mainGUI.startLoad();
    }

    private function onErrorLoadGUI(event:Event):void
    {

    }

    private function onGUILoaded(event:Event):void
    {
        init();
    }

    private function init():void
    {
        ButtonUtil.setButton(_mainGUI.content["buttonBuild"], onBuildClick);
        ButtonUtil.setButton(_mainGUI.content["buttonUp"], onUpClick);
        ButtonUtil.setButton(_mainGUI.content["buttonDown"], onDownClick);
        ButtonUtil.setButton(_mainGUI.content["buttonSettings"], onSettingsClick);
        ButtonUtil.setButton(_mainGUI.content["buttonMoney"], onMoneyClick);
        ButtonUtil.setButton(_mainGUI.content["buttonExp"], onExpClick);
        ButtonUtil.setButton(_mainGUI.content["buttonReal"], onRealClick);
        ButtonUtil.setButton(_mainGUI.content["buttonAllFriends"], onAllFriendsClick);
    }

    private function onBuildClick(e:MouseEvent):void
    {
        dispatchEvent(new UserEvent(UserEvent.BUILD));
    }

    private function onUpClick(e:MouseEvent):void
    {
        dispatchEvent(new UserEvent(UserEvent.TOOL_UP));
    }

    private function onDownClick(e:MouseEvent):void
    {
        dispatchEvent(new UserEvent(UserEvent.TOOL_DOWN));
    }

    private function onSettingsClick(e:MouseEvent):void
    {
        dispatchEvent(new UserEvent(UserEvent.SETTINGS));
    }

    private function onMoneyClick(e:MouseEvent):void
    {
        dispatchEvent(new UserEvent(UserEvent.MONEY));
    }

    private function onExpClick(e:MouseEvent):void
    {
        dispatchEvent(new UserEvent(UserEvent.EXP));
    }

    private function onRealClick(e:MouseEvent):void
    {
        dispatchEvent(new UserEvent(UserEvent.REAL));
    }

    private function onAllFriendsClick(e:MouseEvent):void
    {
        dispatchEvent(new UserEvent(UserEvent.ALL_FRIENDS));
    }

}
}
