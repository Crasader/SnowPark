/**
 * Author: JuzTosS
 * Date: 06.11.12
 */
package config
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

    private static const OBJ_IDENTIFIER:String = "snow_objets_config";

    public function ConfigLoader()
    {
        _loader.addEventListener(BulkLoader.COMPLETE, onAllLoaded);
        _loader.addEventListener(BulkLoader.ERROR, onErrorLoad);
    }

    private function onErrorLoad(event:Event):void
    {
        var type:String = "IO";
        if (event is SecurityErrorEvent) type = "Security";
        Cc.log("error load configs - " + type + "Error");

        dispatchEvent(new LocalEvent(LocalEvent.CONFIG_LOAD_ERROR, true));
    }

    private function onAllLoaded(event:Event):void
    {
        try
        {
            var objects:String = _loader.getText(OBJ_IDENTIFIER);
            Constants._config = YAML.decode(objects);
            dispatchEvent(new LocalEvent(LocalEvent.CONFIG_LOADED, true));
        } catch (e:*)
        {
            Cc.log("error parce configs");
        }
    }

    public function loadConfigs():void
    {
        _loader.add(Constants.CONFIG_PATH, {id:OBJ_IDENTIFIER});
        _loader.start();

    }
}
}
