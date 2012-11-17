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

public class BaseSpaceObjectModel implements IBaseSpaceObjectModel
{

    [Bindable]
    public var _x:int = 0;
    [Bindable]
    public var _y:int = 0;
    [Bindable]
    public var _z:Number = 0;

    [Bindable]
    public var _width:int = 0;
    [Bindable]
    public var _length:int = 0;

    [Bindable]
    public var _space:int = 0;

    private var _config:Object;
    private var _classId:String;

    public function BaseSpaceObjectModel(classId:String, config:Object)
    {
        _classId = classId;
        _config = config;

    }

    public function get classId():String
    {
        return _classId;
    }

    public function destroy():void
    {

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
