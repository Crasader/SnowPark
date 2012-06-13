/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 09.02.12
 * Time: 20:01
 * To change this template use File | Settings | File Templates.
 */
package utils
{
public class ArrayHelper
{
    public function ArrayHelper()
    {
    }

    static public function trace_array(a:Array):void
    {
        trace("----grid----");
        for each(var row:Array in a)
        {
            var col_str:String = "";
            for each(var col:int in row)
            {
                if (col < 10)
                    col_str += " ";

                col_str += col.toString() + " ";
            }
            trace(col_str);
        }
        trace("------------");
    }

    static public function init_2d_array(height:int, width:int, val:* = 0):Array
    {
        var a:Array = [];
        for (var column_num:int = 0; column_num < height; column_num++)
        {
            var column:Array = [];
            for (var row_num:int = 0; row_num < width; row_num++)
                column.push(val);

            a.push(column);
        }

        return a;
    }

    static public function get2DRotatedArray(array:Array):Array
    {
        var rotated_array:Array = ArrayHelper.init_2d_array(array[0].length, array.length);
        for (var i:int = 0; i < array[0].length; i++)
        {
            for (var j:int = array.length - 1; j >= 0; j--)
            {
                rotated_array[i][array.length - j - 1] = array[j][i];
            }
        }

        return rotated_array;
    }

    static public function change2DArraySize(x_size:int, y_size:int, array:Array):Array
    {
        if(x_size > array.length)
        {
            array.length = x_size;
            for (var i:int = 0; i < x_size; i++)
                array[i] ||= [];
        }
        if(y_size > array[0].length)
        {
            for each(var line:Array in array)
            {
                line.length = y_size;
                for (var j:int = 0; j < y_size; j++)
                {
                    line[j] ||= 0;
                }

            }
        }

        return array;
    }


}
}
