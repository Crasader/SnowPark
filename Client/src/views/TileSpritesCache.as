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
		"0000":[tile0000],
		"0001":[tile0001],
		"0010":[tile0010],
		"0011":[tile0010],
		"0100":[tile0100],
		"0101":[tile0101],
		"0110":[tile0110],
		"0111":[tile0111],
		"1000":[tile1000],
		"1001":[tile1001],
		"1010":[tile1010],
		"1011":[tile1011],
		"1100":[tile1100],
		"1101":[tile1101],
		"1110":[tile1110]
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
		var tileClass:Class = tiles[int(Math.random() * tiles.length)];
		return new tileClass();
	}
}
}
