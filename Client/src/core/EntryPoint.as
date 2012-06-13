/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 24.03.12
 * Time: 17:36
 * To change this template use File | Settings | File Templates.
 */
package core
{
import controllers.CoreController;

import flash.display.Sprite;

public class EntryPoint extends Sprite
{
    public function EntryPoint()
    {
        new CoreController(this);
    }
}
}
