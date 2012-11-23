/**
 * Author: JuzTosS
 * Date: 23.11.12
 */
package utils
{
import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.utils.Dictionary;

public class ButtonUtil
{
    private static const _buttons:Dictionary = new Dictionary();

    public function ButtonUtil()
    {
    }

    static public function setButton(button:MovieClip, onClick:Function = null, text:String = null, tfName:String = null, onOver:Function = null, onOut:Function = null):void
    {
        if (_buttons[button]) unsetButton(button);

        button.gotoAndStop(1);
        var btnListeners:Object = {};

        button.addEventListener(MouseEvent.MOUSE_OVER, onClick);
        if (onOver != null) button.addEventListener(MouseEvent.MOUSE_OVER, onOver);
        if (onOut != null) button.addEventListener(MouseEvent.MOUSE_OUT, onOut);

        button.addEventListener(MouseEvent.MOUSE_DOWN, dOnDown);
        button.addEventListener(MouseEvent.MOUSE_UP, dOnUp);
        button.addEventListener(MouseEvent.MOUSE_OVER, dOnOver);
        button.addEventListener(MouseEvent.MOUSE_OUT, dOnOut);

        button.mouseChildren = false;
        button.buttonMode = true;

        if (text && tfName)
        {
            setButtonText(button, text, tfName);
        }

        if (onOver != null) btnListeners["onOver"] = onOver;
        if (onOut != null) btnListeners["onOut"] = onOut;
        if (onClick != null) btnListeners["onClick"] = onClick;

    }

    private static function dOnDown(e:MouseEvent):void
    {
        var b:MovieClip = e.currentTarget as MovieClip;
        if (b.totalFrames >= 3)
            b.gotoAndStop(3);
    }

    private static function dOnUp(e:MouseEvent):void
    {
        var b:MovieClip = e.currentTarget as MovieClip;
        if (b.totalFrames >= 1)
            b.gotoAndStop(1);
    }

    private static function dOnOut(e:MouseEvent):void
    {
        var b:MovieClip = e.currentTarget as MovieClip;
        if (b.totalFrames >= 1)
            b.gotoAndStop(1);
    }

    private static function dOnOver(e:MouseEvent):void
    {
        var b:MovieClip = e.currentTarget as MovieClip;
        if (b.totalFrames >= 2)
            b.gotoAndStop(2);
    }

    static public function unsetButton(button:MovieClip):void
    {
        if (!_buttons[button]) return;

        var btnCallbacks:Object = _buttons[button];

        button.removeEventListener(MouseEvent.CLICK, btnCallbacks["onClick"]);
        button.removeEventListener(MouseEvent.MOUSE_OVER, btnCallbacks["onOver"]);
        button.removeEventListener(MouseEvent.MOUSE_OUT, btnCallbacks["onOut"]);

        button.removeEventListener(MouseEvent.MOUSE_DOWN, dOnDown);
        button.removeEventListener(MouseEvent.MOUSE_UP, dOnUp);
        button.removeEventListener(MouseEvent.MOUSE_OVER, dOnOver);
        button.removeEventListener(MouseEvent.MOUSE_OUT, dOnOut);
    }

    static protected function setButtonText(button:MovieClip, text:String, tfName:String):void
    {
        for (var i:int = 0; i < button.framesLoaded; i++)
            if (button[tfName] is TextField)
            {
                button[tfName].text = text;
            }
    }
}
}
