/**
 * Author: JuzTosS
 * Date: 07.11.12
 */
package utils
{
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.utils.clearTimeout;

public class NodeUtil
{
    public function NodeUtil()
    {
    }

    public static function setTimeout(cb:Function, delay:int, ...params):uint
    {
        var timeoutId:uint = setTimeout(function ():void
        {
            clearTimeout(timeoutId);
            cb.apply(NaN, params);
        }, delay);
        return timeoutId;
    }

    public static function stopMC(mc:Sprite):void
    {
        if (mc is MovieClip) (mc as MovieClip).stop();
        for (var i:int = 0; i < mc.numChildren; i++)
        {
            var child:MovieClip = mc.getChildAt(i) as MovieClip;
            if (child) stopMC(child);
        }
    }
}
}
