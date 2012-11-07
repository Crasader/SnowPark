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

    static public function traceArray(a:Array):void
    {
        trace("----grid----");
        for each(var row:Array in a)
        {
            var colStr:String = "";
            for each(var col:int in row)
            {
                if (col < 10)
                    colStr += " ";

                colStr += col.toString() + " ";
            }
            trace(colStr);
        }
        trace("------------");
    }

    static public function init2dArray(height:int, width:int, val:* = 0):Array
    {
        var a:Array = [];
        for (var columnNum:int = 0; columnNum < height; columnNum++)
        {
            var column:Array = [];
            for (var rowNum:int = 0; rowNum < width; rowNum++)
                column.push(val);

            a.push(column);
        }

        return a;
    }

    static public function get2DRotatedArray(array:Array):Array
    {
        var rotatedArray:Array = ArrayHelper.init2dArray(array[0].length, array.length);
        for (var i:int = 0; i < array[0].length; i++)
        {
            for (var j:int = array.length - 1; j >= 0; j--)
            {
                rotatedArray[i][array.length - j - 1] = array[j][i];
            }
        }

        return rotatedArray;
    }

    static public function change2DArraySize(xSize:int, ySize:int, array:Array):Array
    {
        if (xSize > array.length)
        {
            array.length = xSize;
            for (var i:int = 0; i < xSize; i++)
                array[i] ||= [];
        }
        if (ySize > array[0].length)
        {
            for each(var line:Array in array)
            {
                line.length = ySize;
                for (var j:int = 0; j < ySize; j++)
                {
                    line[j] ||= 0;
                }

            }
        }

        return array;
    }

}
}
