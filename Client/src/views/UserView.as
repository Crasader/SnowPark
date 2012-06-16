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

import models.UserModel;

import mx.binding.utils.BindingUtils;

public class UserView extends Sprite
{
    private var _login_screen:Sprite = new LoginScreen();

    public function UserView()
    {
        addChild(_login_screen);
        connect_btn.addEventListener(MouseEvent.CLICK, on_connect_click);
        create_btn.addEventListener(MouseEvent.CLICK, on_create_click);
        BindingUtils.bindSetter(auth_changed, UserModel.instanse, "_auth_passed");
    }

    private function auth_changed(auth_passed:Boolean):void
    {
        if (auth_passed)
        {
            removeChild(_login_screen);
        }
        else
        {
            addChild(_login_screen);
        }

    }

    private function on_create_click(event:MouseEvent):void
    {
        dispatchEvent(new UserViewEvent(UserViewEvent.CREATE_NEW_USER));
    }

    private function on_connect_click(event:MouseEvent):void
    {
        dispatchEvent(new UserViewEvent(UserViewEvent.AUTH));
    }

    private function get connect_btn():SimpleButton
    {
        return _login_screen.getChildByName("connect_btn") as SimpleButton;
    }

    private function get create_btn():SimpleButton
    {
        return _login_screen.getChildByName("create_btn") as SimpleButton;
    }

    private function get login_tf():TextField
    {
        return _login_screen.getChildByName("login_tf") as TextField;
    }

    private function get password_tf():TextField
    {
        return _login_screen.getChildByName("password_tf") as TextField;
    }

    public function get login_str():String
    {
        return login_tf.text;
    }

    public function get pass_str():String
    {
        return password_tf.text;
    }
}
}
