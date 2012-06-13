/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 24.03.12
 * Time: 21:42
 * To change this template use File | Settings | File Templates.
 */
package models
{
import flash.events.Event;
import flash.events.EventDispatcher;

public class CameraModel extends EventDispatcher
{
    private static var _instanse:CameraModel;

    [Bindable]
    public var _x:int = 0;
    [Bindable]
    public var _y:int = 0;
    [Bindable]
    public var _zoom:Number = 1;

    private const ZOOM_DELTA:Number = 0.1;
    private const ZOOM_MAX:Number = 2;
    private const ZOOM_MIN:Number = 0.5;

    public function CameraModel()
    {
    }

    public static function get instanse():CameraModel
    {
        if(_instanse == null)
        {
            _instanse = new CameraModel();
        }

        return _instanse;
    }

    public function set_postion(x:Number,  y:Number):void
    {
        _x = x;
        _y = y;
    }

    public function zoom_down():void
    {
        _zoom = check_zoom_value(_zoom - ZOOM_DELTA);
    }

    public function zoom_up():void
    {
        _zoom = check_zoom_value(_zoom + ZOOM_DELTA);
    }
    
    private function check_zoom_value(zoom:Number):Number
    {
        if(zoom > ZOOM_MAX)
            return ZOOM_MAX;
        
        if(zoom < ZOOM_MIN)
            return ZOOM_MIN;
        
        return zoom;
    }
}
}
