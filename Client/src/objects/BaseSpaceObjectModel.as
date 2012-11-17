/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 14.04.12
 * Time: 21:17
 * To change this template use File | Settings | File Templates.
 */
package objects
{
import com.junkbyte.console.Cc;

import objects.components.IComponent;
import objects.components.riderComponent;

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

    private static const REGISTERED_COMPONENTS:Array = [riderComponent];
    private static var _componentsHash:Object = {};

    private var _components:Array = [];

    public static function registerComponets():void
    {
        for each(var componentClass:Class in REGISTERED_COMPONENTS)
            _componentsHash[componentClass.name] = componentClass;
    }

    public function BaseSpaceObjectModel(classId:String, config:Object)
    {
        _classId = classId;
        _config = config;

        loadComponents();

    }

    private function loadComponents():void
    {
        if (!cfgComponents) return;
        for each(var cCfg:Object in cfgComponents)
        {
            var cClass:Class = _componentsHash[cCfg.name];
            if (!cClass)
            {
                Cc.error("component not found, name: " + cCfg.name + " classId: " + _classId);
                continue;
            }

            var component:IComponent = new cClass();
            component.loadConfig(cCfg);
            _components.push(component);
        }
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

    private function get cfgComponents():Object
    {
        return cfgBehavior.components;
    }

    public function tick(dt:Number):void
    {
        for each(var c:IComponent in _components)
            c.tick(dt);
    }

    public function onFrame(dt:Number):void
    {
        for each(var c:IComponent in _components)
            c.onFrame(dt);
    }
}
}
