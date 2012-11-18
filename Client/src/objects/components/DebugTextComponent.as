/**
 * Author: JuzTosS
 * Date: 18.11.12
 */
package objects.components
{
import as3isolib.display.IsoSprite;

import flash.display.Sprite;
import flash.text.TextField;

import objects.ObjectModel;

public class DebugTextComponent extends BaseComponent
{
    private var _debugTF:TextField;

    public function DebugTextComponent(m:ObjectModel)
    {
        super(m);
        _debugTF = new TextField();
    }

    override public function updatePos(view:IsoSprite, mainSprite:Sprite, dt:Number):void
    {
        _debugTF.y = -mainSprite.height - mainSprite.y;

        _debugTF.text = "X=" + model.x + ", Y=" + model.y;
    }

    override public function get sprites():Array
    {
        return [_debugTF];
    }

    public static function get name():String
    {
        return "debugText";
    }
}
}
