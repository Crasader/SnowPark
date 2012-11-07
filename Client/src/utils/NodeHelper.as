/**
 * Author: JuzTosS
 * Date: 07.11.12
 */
package utils
{
import flash.utils.clearTimeout;

public class NodeHelper
{
    public function NodeHelper()
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
}
}
