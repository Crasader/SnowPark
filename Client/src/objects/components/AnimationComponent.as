/**
 * Author: JuzTosS
 * Date: 17.11.12
 */
package objects.components
{
import objects.ObjectModel;

public class AnimationComponent extends BaseComponent
{
    public function AnimationComponent(m:ObjectModel)
    {
        super(m);
    }

    override public function onFrame(dt:Number):void
    {

    }

    override public function get sprites():Array
    {
        return super.sprites;
    }
}
}
