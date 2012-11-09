/**
 * Author: JuzTosS
 * Date: 11.06.12
 */
package views
{

import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;

import models.IBindableModel;

import mx.binding.utils.BindingUtils;

public class UserView extends Sprite
{
    private var _loginScreen:Sprite = new LoginScreen();

    public function UserView(model:IBindableModel)
    {
        addChild(_loginScreen);
        connectBtn.addEventListener(MouseEvent.CLICK, onConnectClick);
        createBtn.addEventListener(MouseEvent.CLICK, onCreateClick);
        BindingUtils.bindSetter(authChanged, model, "_authPassed");
    }

    private function authChanged(authPassed:Boolean):void
    {
        if (authPassed)
        {
            removeChild(_loginScreen);
        }
        else
        {
            addChild(_loginScreen);
        }

    }

    private function onCreateClick(event:MouseEvent):void
    {
        dispatchEvent(new UserViewEvent(UserViewEvent.CREATE_NEW_USER));
    }

    private function onConnectClick(event:MouseEvent):void
    {
        dispatchEvent(new UserViewEvent(UserViewEvent.AUTH));
    }

    private function get connectBtn():SimpleButton
    {
        return _loginScreen.getChildByName("connect_btn") as SimpleButton;
    }

    private function get createBtn():SimpleButton
    {
        return _loginScreen.getChildByName("create_btn") as SimpleButton;
    }

    private function get loginTF():TextField
    {
        return _loginScreen.getChildByName("login_tf") as TextField;
    }

    private function get passwordTF():TextField
    {
        return _loginScreen.getChildByName("password_tf") as TextField;
    }

    public function get loginStr():String
    {
        return loginTF.text;
    }

    public function get passStr():String
    {
        return passwordTF.text;
    }
}
}
