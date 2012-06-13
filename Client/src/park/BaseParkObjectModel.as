/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 14.04.12
 * Time: 21:17
 * To change this template use File | Settings | File Templates.
 */
package park
{
public class BaseParkObjectModel
{
    [Bindable]
    public var _x:int = 0;
    [Bindable]
    public var _y:int = 0;

    [Bindable]
    public var _width:int = 1;

    [Bindable]
    public var _length:int = 1;

    public function BaseParkObjectModel()
    {
    }
}
}
