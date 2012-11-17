/**
 * Author: JuzTosS
 * Date: 17.11.12
 */
package objects.components
{
public class riderComponent extends IComponent
{
    public function riderComponent()
    {
    }

    override public function tick(dt:Number):void
    {

    }

    public static function get name():String
    {
        return "rider";
    }

    override public function loadConfig(cfg:Object):void
    {

    }

}
}
