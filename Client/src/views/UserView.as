/**
 * Author: JuzTosS
 * Date: 11.06.12
 */
package views
{

import com.junkbyte.console.Cc;

import events.UserEvent;
import events.UserViewEvent;

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.ui.Mouse;
import flash.ui.MouseCursorData;

import models.FieldModel;
import models.IBindableModel;

import views.windows.BaseWindow;
import views.windows.MainGui;
import views.windows.ShopWindow;
import views.windows.SimplePopup;

public class UserView extends Sprite
{
    private static const GUI_LAYER:int = 1;
    private static const WINDOW_LAYER:int = 2;

    private static const DEFAULT_CURSOR:String = "snowDefaultCursor";
    private static const DESTROY_CURSOR:String = "snowDestroyCursor";
    private static const UP_CURSOR:String = "snowUpCursor";
    private static const DOWN_CURSOR:String = "snowDownCursor";

    private var _mainGui:BaseWindow = new MainGui();
    private var _shopWindow:BaseWindow = new ShopWindow();

    private var _windowLayer:Sprite = new Sprite();
    private var _mainGuiLayer:Sprite = new Sprite();
    private var _cursorLayer:Sprite = new Sprite();

    public function UserView(model:IBindableModel)
    {
        addChildsWithOrder();
        showMainGUI();
        initCursors();

        addEventListener(UserViewEvent.SHOW_SHOP_WND, showShopWindow);
        addEventListener(UserViewEvent.SHOW_POPUP, showPopUp);
    }

    public function onToolChanged(e:UserEvent):void
    {
        if (e.data == FieldModel.DESTROY_TOOL)
        {
            Mouse.cursor = DESTROY_CURSOR;
        }
        else if (e.data == FieldModel.UP_TOOL)
        {
            Mouse.cursor = UP_CURSOR;
        }
        else if (e.data == FieldModel.DOWN_TOOL)
        {
            Mouse.cursor = DOWN_CURSOR;
        }
        else
        {
            Mouse.cursor = DEFAULT_CURSOR;
        }
    }

    private function initCursors():void
    {
        registerCursor(new CursorArrowSprite(), DEFAULT_CURSOR);
        registerCursor(new CursorDestroySprite(), DESTROY_CURSOR);
        registerCursor(new CursorUpHeight(), UP_CURSOR);
        registerCursor(new CursorDownHeight(), DOWN_CURSOR);
        Mouse.cursor = DEFAULT_CURSOR;

    }

    private function registerCursor(cursorSprite:Sprite, name:String):void
    {
        var cursorBmpData:BitmapData = new BitmapData(cursorSprite.width + 1, cursorSprite.height + 1, true, 0);
        cursorBmpData.draw(cursorSprite);
        var mouseCursorData:MouseCursorData = new MouseCursorData();
        var cursorData:Vector.<BitmapData> = new Vector.<BitmapData>();
        cursorData.push(cursorBmpData);
        mouseCursorData.data = cursorData;

        Mouse.registerCursor(name, mouseCursorData);
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
        addChild(_cursorLayer);
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
