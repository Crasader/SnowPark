/**
 * Author: JuzTosS
 * Date: 07.11.12
 */
package utils
{
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

public class NodeHelper
{
    public function NodeHelper()
    {
    }

    public static function set_timeout(cb:Function, delay:int, ...params):uint
    {
        var timeout_id:uint = setTimeout(function ():void
        {
            clearTimeout(timeout_id);
            cb.apply(NaN, params);
        }, delay);
        return timeout_id;
    }
}
}
