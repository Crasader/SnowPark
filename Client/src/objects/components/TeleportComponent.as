/**
 * Author: JuzTosS
 * Date: 18.11.12
 */
package objects.components
{
import config.Constants;

import objects.ObjectModel;

public class TeleportComponent extends BaseComponent
{
    public function TeleportComponent(m:ObjectModel)
    {
        super(m);
    }

    override public function updatePos(dt:Number):void
    {
        view.x = Constants.TILE_SIZE * model.x;
        view.y = Constants.TILE_SIZE * model.y;
        view.z = Constants.TILE_HEIGHT * model.z;
    }

    public static function get name():String
    {
        return "teleport";
    }
}
}
