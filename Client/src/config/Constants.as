/**
 * Author: JuzTosS
 * Date: 10.06.12
 */
package config
{
import com.junkbyte.console.Cc;

public class Constants
{
    public static const VERSION:String = "v.0.01";
    public static const APP_NAME:String = "Snow Prototipe";
    public static const SERVER_URL:String = "http://juztoss.zapto.org/";

    public static const WORLD_TIMER_INTERVAL:int = 10; //ms

    public static const MAX_NUM_OF_COMMANDS:int = 64;
    public static const SEND_REQUESTS_INTERVAL:int = 5000; //ms

    public static const CONFIG_PATH:String = "http://juztoss.zapto.org:5000/config/objects.yml";
    public static const GRAPHICS_PATH:String = "http://juztoss.zapto.org:5000/graphics/";

    public static const STAGE_WIDTH:int = 800;
    public static const STAGE_HEIGHT:int = 600;
    public static const TILE_SIZE:int = 20;
    public static const TILE_HEIGHT:int = 10;
    public static const MOUSEMAP_HEIGHT_MARGIN:int = 400;

    internal static var _config:Object;

    public static function get CFG():Object
    {
        if (!_config) Cc.error("Null CFG!");
        return _config;
    }

    public static function get MAX_FIELD_SIZE():int
    {
        return CFG.maxFieldSize;
    }

    public function Constants()
    {
    }
}
}
