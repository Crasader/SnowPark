/**
 * Author: JuzTosS
 * Date: 05.06.12
 */
package debug
{
import com.junkbyte.console.Cc;

import flash.display.DisplayObjectContainer;

import flash.events.Event;

public class Console
{
    public function Console()
    {
    }

    public static function init(stage:DisplayObjectContainer):void
    {
        Cc.startOnStage(stage, "");
        Cc.width = 480;
        Cc.commandLine = true;
        Cc.config.commandLineAllowed = true;
    }
}
}
