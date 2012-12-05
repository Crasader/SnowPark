/**
 * Author: JuzTosS
 * Date: 04.12.12
 */
package objects.components
{
import flash.display.Sprite;
import flash.filters.GlowFilter;

import objects.ObjectModel;

public class HightlightComponent extends BaseComponent
{
    public function HightlightComponent(m:ObjectModel)
    {
        super(m);
    }

    override public function mouseOn():void
    {
        for each(var s:Sprite in view.actualSprites)
        {
            s.filters = [new GlowFilter()];
        }
    }

    public static function get name():String
    {
        return "hightlight";
    }

    override public function mouseOff():void
    {
        for each(var s:Sprite in view.actualSprites)
        {
            s.filters = [];
        }
    }

    override public function mouseClick():void
    {
        for each(var s:Sprite in view.actualSprites)
        {
            s.alpha -= 0.1;
        }
    }
}
}
