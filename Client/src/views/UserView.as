/**
 * Author: JuzTosS
 * Date: 11.06.12
 */
package views
{

import com.junkbyte.console.Cc;

import events.UserViewEvent;

import flash.display.Sprite;
import flash.events.Event;

import models.IBindableModel;

import views.windows.BaseWindow;
import views.windows.MainGui;
import views.windows.ShopWindow;
import views.windows.SimplePopup;

public class UserView extends Sprite
{
    private static const GUI_LAYER:int = 1;
    private static const WINDOW_LAYER:int = 2;

    private var _mainGui:BaseWindow = new MainGui();
    private var _shopWindow:BaseWindow = new ShopWindow();

    private var _windowLayer:Sprite = new Sprite();
    private var _mainGuiLayer:Sprite = new Sprite();

    public function UserView(model:IBindableModel)
    {
        addChildsWithOrder();
        showMainGUI();

        addEventListener(UserViewEvent.SHOW_SHOP_WND, showShopWindow);
        addEventListener(UserViewEvent.SHOW_POPUP, showPopUp);
    }

    private function showPopUp(event:UserViewEvent):void
    {
        showWindow(new SimplePopup(event.params.header, event.params.content), WINDOW_LAYER);
    }

    private function showMainGUI():void
    {
        showWindow(_mainGui, GUI_LAYER);
    }

    private function showShopWindow(e:Event):void
    {
        showWindow(_shopWindow, WINDOW_LAYER);
    }

    private function addChildsWithOrder():void
    {
        addChild(_mainGuiLayer);
        addChild(_windowLayer);
    }

    private function showWindow(window:BaseWindow, layer:int):void
    {
        var layerSprite:Sprite = getLayer(layer);
        if (!layerSprite)
        {
            Cc.warn("Unknown layer!");
            return;
        }

        window.addEventListener(UserViewEvent.CLOSE_WND, onCloseWindow);

        layerSprite.addChild(window);
    }

    private function onCloseWindow(e:UserViewEvent):void
    {
        var wnd:BaseWindow = e.currentTarget as BaseWindow;
        wnd.removeEventListener(UserViewEvent.CLOSE_WND, onCloseWindow);
        _windowLayer.removeChild(wnd);
    }

    private function getLayer(layer:int):Sprite
    {
        var layerSprite:Sprite;
        switch (layer)
        {
            case GUI_LAYER:
                layerSprite = _mainGuiLayer;
                break;
            case WINDOW_LAYER:
                layerSprite = _windowLayer
                break;
        }
        return layerSprite;
    }

}
}
