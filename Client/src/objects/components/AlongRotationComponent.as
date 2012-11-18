/**
 * Author: JuzTosS
 * Date: 18.11.12
 */
package objects.components
{
import objects.ObjectModel;

public class AlongRotationComponent extends BaseComponent
{
    public function AlongRotationComponent(m:ObjectModel)
    {
        super(m);
    }

    override public function updatePos(dt:Number):void
    {
        if (model.fieldModel.getHeight(model.x, model.y) > model.fieldModel.getHeight(model.x + 1, model.y))
        {
            loader.rotation = 45;
        }
        else
            loader.rotation = 0;
    }

    public static function get name():String
    {
        return "alongRotation";
    }
}
}
