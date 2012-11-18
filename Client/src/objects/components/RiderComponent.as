/**
 * Author: JuzTosS
 * Date: 17.11.12
 */
package objects.components
{
import objects.ObjectModel;

public class RiderComponent extends BaseComponent
{
    private var _speed:Number = 0; //unit/s
    private var _updateDelataTime:Number = 0; //s
    private var _normalDelataTime:Number = 0; //s
    private var _lastUpdateTime:Number = 0;

    public function RiderComponent(m:ObjectModel)
    {
        super(m);
    }

    override public function tick(dt:Number):void
    {
        var now:Number = new Date().time;
        if ((now <= (_lastUpdateTime + _updateDelataTime)) && (_lastUpdateTime != 0)) return;

        step();
        _lastUpdateTime = now;
    }

    private function step():void
    {
        _updateDelataTime = _normalDelataTime;
        var new_x:int = model.x + 1;
        var new_y:int = model.y;

        if (model.fieldModel.isPlaceFree(new_x, new_y))
        {
            model.setPos(new_x, new_y);
            return;
        }

        _updateDelataTime *= 1.41;
        new_y += 1;
        if (model.fieldModel.isPlaceFree(new_x, new_y))
        {
            model.setPos(new_x, new_y);
            return;
        }

        new_y -= 2;
        if (model.fieldModel.isPlaceFree(new_x, new_y))
        {
            model.setPos(new_x, new_y);
            return;
        }
    }

    public static function get name():String
    {
        return "rider";
    }

    override public function loadConfig(cfg:Object):void
    {
        _speed = cfg.speed;
        _normalDelataTime = 1000 / _speed;
    }

}
}
