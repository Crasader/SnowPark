/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 14.04.12
 * Time: 21:17
 * To change this template use File | Settings | File Templates.
 */
package objects
{
import as3isolib.geom.Pt;

import com.junkbyte.console.Cc;

import events.ObjectEvent;

import flash.events.Event;

import flash.events.EventDispatcher;

import models.IFieldModel;

import objects.components.AlongRotationComponent;
import objects.components.BaseComponent;
import objects.components.DebugTextComponent;
import objects.components.HightlightComponent;
import objects.components.IViewComponent;
import objects.components.LiftDownsite;
import objects.components.LiftPillar;
import objects.components.LiftUpsite;
import objects.components.MoveComponent;
import objects.components.RiderComponent;
import objects.components.SimpleAnimationComponent;
import objects.components.TeleportComponent;

public class ObjectModel extends EventDispatcher implements IObjectModel
{
    private var _x:int = 0;
    private var _y:int = 0;
    private var _z:int = 0;

    [Bindable]
    public var _space:int = 0;

    private var _cfg:Object;
    private var _classId:String;

    public static const REGISTERED_COMPONENTS:Array = [
            RiderComponent,
            MoveComponent,
            SimpleAnimationComponent,
            TeleportComponent,
            AlongRotationComponent,
            DebugTextComponent,
            HightlightComponent,
            LiftUpsite,
            LiftDownsite,
            LiftPillar
    ];

    private static var _componentsHash:Object = {};

    private var _components:Vector.<IViewComponent> = new Vector.<IViewComponent>();
    private var _fieldModel:IFieldModel;

    public static function registerComponets():void
    {
        for each(var componentClass:Class in REGISTERED_COMPONENTS)
            _componentsHash[componentClass.name] = componentClass;
    }

    public function ObjectModel(classId:String, config:Object, fieldModel:IFieldModel)
    {
        _fieldModel = fieldModel;
        _classId = classId;
        _cfg = config;

        loadComponents();
    }

    public function setPos(x:int, y:int):void
    {
        var oldPos:Pt = new Pt(_x, _y, _z);
        _x = x;
        _y = y;
        _z = fieldModel.getHeight(x, y);

        dispatchEvent(new ObjectEvent(ObjectEvent.POSITION_UPDATED, oldPos, new Pt(_x, _y, _z)));
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

            var component:BaseComponent = new cClass(this);
            component.loadConfig(cCfg);
            _components.push(component);
        }
    }

    public function get classId():String
    {
        return _classId;
    }

    public function get cfg():Object
    {
        if (!_cfg) Cc.error("Null config in object with id " + classId);
        return _cfg;
    }

    public function get cfgView():Object
    {
        if (!cfg.view) Cc.error("Null view cfg in object with id " + classId);
        return cfg.view;
    }

    public function get cfgShop():Object
    {
        if (!cfg.shop) Cc.error("Null shop cfg in object with id " + classId);
        return cfg.shop;
    }

    public function get cfgBehavior():Object
    {
        if (!cfg.behavior) Cc.error("Null behavior cfg in object with id " + classId);
        return cfg.behavior;
    }

    public function get cfgDescriptions():Object
    {
        if (!cfg.descriptions) Cc.error("Null descriptions cfg in object with id " + classId);
        return cfg.descriptions;
    }

    private function get cfgComponents():Object
    {
        return cfgBehavior.components;
    }

    public function tick(dt:Number):void
    {
        for each(var c:BaseComponent in _components)
            c.tick(dt);
    }

    public function onFrame(dt:Number):void
    {
        for each(var c:BaseComponent in _components)
            c.onFrame(dt);
    }

    public function get fieldModel():IFieldModel
    {
        return _fieldModel;
    }

    public function get x():int
    {
        return _x;
    }

    public function get y():int
    {
        return _y;
    }

    public function get z():int
    {
        return _z;
    }

    public function get components():Vector.<IViewComponent>
    {
        return _components;
    }

    public function destroy():void
    {
        for each(var c:BaseComponent in _components)
            c.destroy();
    }
}
}
