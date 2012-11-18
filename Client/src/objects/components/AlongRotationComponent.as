/**
 * Author: JuzTosS
 * Date: 18.11.12
 */
package objects.components
{
import as3isolib.display.IsoSprite;

import flash.display.Sprite;

import objects.ObjectModel;

public class AlongRotationComponent extends BaseComponent
{
    public function AlongRotationComponent(m:ObjectModel)
    {
        super(m);
    }

    override public function updatePos(view:IsoSprite, mainSprite:Sprite, dt:Number):void
    {
        if (model.fieldModel.getHeight(model.x, model.y) > model.fieldModel.getHeight(model.x + 1, model.y))
        {
            mainSprite.rotation = 45;
        }
        else
            mainSprite.rotation = 0;
    }

    public static function get name():String
    {
        return "alongRotation";
    }
}
}
