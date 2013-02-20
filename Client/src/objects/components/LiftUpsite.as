/**
 * Author: JuzTosS
 * Date: 04.12.12
 */
package objects.components
{
import flash.display.Sprite;
import flash.filters.GlowFilter;

import objects.ObjectModel;

public class LiftUpsite extends BaseComponent
{
    public function LiftUpsite(m:ObjectModel)
    {
        super(m);
    }

    public static function get name():String
    {
        return "liftUpSite";
    }
}
}
