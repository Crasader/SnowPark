/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 14.04.12
 * Time: 21:26
 * To change this template use File | Settings | File Templates.
 */
package park.static
{
import flash.events.Event;
import flash.utils.setInterval;

import park.BaseParkObjectModel;

public class SimpleBlockModel extends BaseParkObjectModel
{
    [Bindable]
    public var _height:int = 0;

    public function SimpleBlockModel()
    {
        _height = 10 + Math.random() * 30;
//        setInterval(changeHeight, 50 + Math.random() * 30)
    }

//    private var _multipiler:int = 1;
//    private function changeHeight():void
//    {
//        if(_height < 5 || _height > 50)
//        {
//            _multipiler *= -1;
//        }
//        _height += 2 * _multipiler;
//
//    }
}
}
