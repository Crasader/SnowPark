/**
 * Author: JuzTosS
 * Date: 04.12.12
 */
package objects.components
{
import objects.ObjectModel;

public class LiftPillar extends BaseComponent
{
    public function LiftPillar(m:ObjectModel)
    {
        super(m);
    }

    public static function get name():String
    {
        return "liftPillar";
    }
}
}
