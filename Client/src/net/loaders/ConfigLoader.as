/**
 * Author: JuzTosS
 * Date: 06.11.12
 */
package net.loaders
{
import basemvc.controller.CompositeController;

import br.com.stimuli.loading.BulkLoader;

import com.junkbyte.console.Cc;

import controllers.events.LocalEvent;

import flash.events.Event;
import flash.events.SecurityErrorEvent;

import org.as3yaml.YAML;

public class ConfigLoader extends CompositeController
{
    private var _loader:BulkLoader = new BulkLoader("snow configs loader");
    private var _objects_config:Object;
    [Bindable]
    public var objects_config_loaded:Boolean = false;

    public function ConfigLoader()
    {
        _loader.addEventListener(BulkLoader.COMPLETE, on_all_loaded);
        _loader.addEventListener(BulkLoader.ERROR, on_error_load);
    }

    private function on_error_load(event:Event):void
    {
        var type:String = "IO";
        if (event is SecurityErrorEvent) type = "Security"
        Cc.log("error load configs - " + type + "Error");

        dispatchEvent(new LocalEvent(LocalEvent.CONFIG_LOAD_ERROR, true));
    }

    private function on_all_loaded(event:Event):void
    {
        try
        {
            var objects:String = _loader.getText("objects");
            _objects_config = YAML.decode(objects);
            dispatchEvent(new LocalEvent(LocalEvent.CONFIG_LOADED, true));
        } catch (e:*)
        {
            Cc.log("error parce configs");
        }
    }

    public function load_configs():void
    {
        _loader.add("http://127.0.0.1/config/objects.yml", {id:"objects"});
        _loader.start();

    }

    public function get objects_config():Object
    {
        return _objects_config;
    }
}
}
