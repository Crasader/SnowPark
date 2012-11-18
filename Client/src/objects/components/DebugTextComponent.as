/**
 * Author: JuzTosS
 * Date: 18.11.12
 */
package objects.components
{
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

    override public function updatePos(dt:Number):void
    {
        _debugTF.y = -loader.height - loader.y;

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
