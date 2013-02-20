/**
 * Author: JuzTosS
 * Date: 04.12.12
 */
package objects.components
{
import objects.ObjectModel;

public class LiftDownsite extends BaseComponent
{
    public function LiftDownsite(m:ObjectModel)
    {
        super(m);
    }

    public static function get name():String
    {
        return "liftDownSite";
    }
}
}
