/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 21.03.12
 * Time: 20:44
 * To change this template use File | Settings | File Templates.
 */
package models
{
import park.BaseParkObjectController;
import park.BaseParkObjectModel;

import utils.ArrayHelper;
import utils.IntPnt;

public class SnowParkField
{
    private static const WIDTH:int = 15;
    private static const HEIGHT:int = 15;

    private var _field:Array;

    public function SnowParkField()
    {
        _field = ArrayHelper.init_2d_array(WIDTH, HEIGHT, null);
    }

    public function setBlock(pos:IntPnt, obj:BaseParkObjectModel):void
    {
        _field[pos.x][pos.y] = obj;
    }

    public function getBlock(pos:IntPnt):BaseParkObjectModel
    {
        return _field[pos.x][pos.y];
    }

    public function get width():int
    {
        return WIDTH;
    }

    public function get height():int
    {
        return HEIGHT;
    }

}
}
