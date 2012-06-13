/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 21.03.12
 * Time: 21:10
 * To change this template use File | Settings | File Templates.
 */
package utils
{
public class IntPnt
{
    public var x:int = 0;
    public var y:int = 0;

    public function IntPnt(X:int = 0, Y:int = 0)
    {
        this.x = X;
        this.y = Y;
    }
    
    public function clone():IntPnt
    {
        return new IntPnt(x, y);
    }
}
}
