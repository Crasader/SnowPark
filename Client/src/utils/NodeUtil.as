/**
 * Author: JuzTosS
 * Date: 07.11.12
 */
package utils
{
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.utils.clearTimeout;

public class NodeUtil
{
	public function NodeUtil()
	{
	}

	public static function stopMC(mc:Sprite):void
	{
		if (mc is MovieClip)
		{
			(mc as MovieClip).stop();
		}
		for (var i:int = 0; i < mc.numChildren; i++)
		{
			var child:MovieClip = mc.getChildAt(i) as MovieClip;
			if (child)
			{
				stopMC(child);
			}
		}
	}

	private static var _cache:Object = {};

	public static function getCached(key:String, params:Array):*
	{
		var cache:Array = _cache[key];
		if (!cache)
		{
			return null;
		}

		for each(var cacheObj:Object in cache)
		{
			if (isArraysEqual(cacheObj.params, params))
			{
				return cacheObj.val;
			}
		}

		return null;
	}

	public static function setCached(key:String, params:Array, val:*, count:int = 1):void
	{
		var cacheObj:Object = {val:val, params:params};
		var cache:Array = _cache[key];
		while (cache.length > count)
			cache.shift();

		cache.push(cacheObj);
	}

	public static function isArraysEqual(a:Array, b:Array):Boolean
	{
		if (a.length != b.length)
		{
			return false;
		}

		var length:int = a.length;
		for (var i:int = 0; i < length; i++)
		{
			if (a[i] != b[i])
			{
				return false;
			}
		}

		return true;
	}
}
}
