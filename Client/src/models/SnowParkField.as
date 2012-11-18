/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 21.03.12
 * Time: 20:44
 * To change this template use File | Settings | File Templates.
 */
package models
{
import config.Constants;

import objects.ObjectModel;

import utils.ArrayHelper;
import utils.IntPnt;

public class SnowParkField
{
    private var _field:Array;

    public function SnowParkField()
    {
        _field = ArrayHelper.init2dArray(Constants.MAX_FIELD_SIZE, Constants.MAX_FIELD_SIZE, null);
    }

    public function setBlock(pos:IntPnt, obj:ObjectModel):void
    {
        _field[pos.x][pos.y] = obj;
    }

    public function getBlock(pos:IntPnt):ObjectModel
    {
        return _field[pos.x][pos.y];
    }

}
}
