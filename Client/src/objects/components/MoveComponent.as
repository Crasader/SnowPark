/**
 * Author: JuzTosS
 * Date: 18.11.12
 */
package objects.components
{
import as3isolib.display.IsoSprite;

import com.gskinner.motion.GTween;

import config.Constants;

import flash.display.Sprite;

import objects.ObjectModel;

public class MoveComponent extends BaseComponent
{
    public function MoveComponent(m:ObjectModel)
    {
        super(m);
    }

    override public function updatePos(view:IsoSprite, mainSprite:Sprite, dt:Number):void
    {
        var nx:Number = Constants.TILE_SIZE * model.x;
        var ny:Number = Constants.TILE_SIZE * model.y;
        var nz:Number = Constants.TILE_HEIGHT * model.z;

        new GTween(view, dt, {x:nx, y:ny, z:nz});
    }

    public static function get name():String
    {
        return "move";
    }
}
}