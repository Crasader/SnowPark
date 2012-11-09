/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 14.04.12
 * Time: 21:17
 * To change this template use File | Settings | File Templates.
 */
package park
{
import com.junkbyte.console.Cc;

import mx.binding.utils.BindingUtils;

public class BaseSpaceObjectModel implements IBaseSpaceObjectModel
{
    private static const HEIGHT_MULTIPLIER:Number = -1.5; //Крутизна склона
    private static const HEIGHT_SHIFT:Number = 10; //Точка начала склона

    [Bindable]
    public var _x:int = 0;
    [Bindable]
    public var _y:int = 0;
    [Bindable]
    public var _z:int = 0;

    [Bindable]
    public var _width:int = 0;
    [Bindable]
    public var _length:int = 0;

    [Bindable]
    public var _group:int = 0;

    [Bindable]
    public var _objectId:int = 0;

    private var _config:Object;
    private var _classId:String;

    public function BaseSpaceObjectModel(objectId:int, classId:String, config:Object)
    {
        _objectId = objectId;
        _classId = classId;
        _config = config;

        BindingUtils.bindSetter(updateZPos, this, "_x");
    }

    public function get classId():String
    {
        return _classId;
    }

    public function destroy():void
    {

    }

    public function updateZPos(value:int):void
    {
        var new_z:int = value * HEIGHT_MULTIPLIER + HEIGHT_SHIFT;
        if (new_z < 0) new_z = 0;
        _z = new_z;
    }

    public function get config():Object
    {
        if (!_config) Cc.error("Null config in object with id " + classId);
        return _config;
    }

    public function get cfgView():Object
    {
        if (!config.view) Cc.error("Null view cfg in object with id " + classId);
        return config.view;
    }

    public function get cfgShop():Object
    {
        if (!config.shop) Cc.error("Null shop cfg in object with id " + classId);
        return config.shop;
    }

    public function get cfgBehavior():Object
    {
        if (!config.behavior) Cc.error("Null behavior cfg in object with id " + classId);
        return config.behavior;
    }

    public function get cfgDescriptions():Object
    {
        if (!config.descriptions) Cc.error("Null descriptions cfg in object with id " + classId);
        return config.descriptions;
    }
}
}
