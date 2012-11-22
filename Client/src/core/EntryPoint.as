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
import flash.events.Event;

public class EntryPoint extends Sprite
{
    public function EntryPoint()
    {

        if (stage)
            init();
        else
            addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(event:Event = null):void
    {
        removeEventListener(Event.ADDED_TO_STAGE, init);
        new CoreController(this);
    }
}
}
