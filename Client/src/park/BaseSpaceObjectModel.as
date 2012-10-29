/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 14.04.12
 * Time: 21:17
 * To change this template use File | Settings | File Templates.
 */
package park
{
import flash.net.registerClassAlias;

public class BaseSpaceObjectModel
{
    [Bindable]
    public var _x:int = 0;
    [Bindable]
    public var _y:int = 0;

    [Bindable]
    public var _width:int = 0;
    [Bindable]
    public var _length:int = 0;

    [Bindable]
    public var _group:int = 0;

    [Bindable]
    public var object_id:int = 0;


    public function BaseSpaceObjectModel()
    {
    }

    public function class_id():int
    {
        return 0;
    }
}
}
