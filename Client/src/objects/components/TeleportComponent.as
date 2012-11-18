/**
 * Author: JuzTosS
 * Date: 18.11.12
 */
package objects.components
{
import as3isolib.display.IsoSprite;

import config.Constants;

import flash.display.Sprite;

import objects.ObjectModel;

public class TeleportComponent extends BaseComponent
{
    public function TeleportComponent(m:ObjectModel)
    {
        super(m);
    }

    override public function updatePos(view:IsoSprite, mainSprite:Sprite, dt:Number):void
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
