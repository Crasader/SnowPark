/**
 * Author: JuzTosS
 * Date: 03.12.12
 */
package views
{
import flash.display.DisplayObject;
import flash.display.Sprite;

internal class TileSpritesCache
{
    private static var _tiles:Object = {
        "0000":[new tile0000()],
        "0001":[new tile0001()],
        "0010":[new tile0010()],
        "0011":[new tile0010()],
        "0100":[new tile0100()],
        "0101":[new tile0101()],
        "0110":[new tile0110()],
        "0111":[new tile0111()],
        "1000":[new tile1000()],
        "1001":[new tile1001()],
        "1010":[new tile1010()],
        "1011":[new tile1011()],
        "1100":[new tile1100()],
        "1101":[new tile1101()],
        "1110":[new tile1110()]
    };

    internal static function getNewSprite(left:int, up:int, right:int, down:int):DisplayObject
    {
        var min:int = Math.min(left, up, right, down);
        var nLeft:int = left - min;
        var nUp:int = up - min;
        var nRight:int = right - min;
        var nDown:int = down - min;
        var tileKey:String = nDown.toString() + nLeft.toString() + nUp.toString() + nRight.toString();
        if (!_tiles[tileKey])
        {
            trace(tileKey);
            return new Sprite();
        }

        var tiles:Array = _tiles[tileKey];
        var tile:DisplayObject = tiles[int(Math.random() * tiles.length)];
        return tile;
    }
}
}
