/**
 * Author: JuzTosS
 * Date: 06.11.12
 */
package config
{
import basemvc.controller.CompositeController;

import br.com.stimuli.loading.BulkLoader;

import com.junkbyte.console.Cc;

import events.CoreEvent;

import flash.events.Event;
import flash.events.SecurityErrorEvent;

import org.as3yaml.YAML;

public class ConfigLoader extends CompositeController
{
    private var _loader:BulkLoader = new BulkLoader("snow configs loader");

    private static const OBJ_IDENTIFIER:String = "snow_objets_config";
    private var _path:String = Constants.CONFIG_PATH;

    public function ConfigLoader()
    {
        _path += "?=" + new Date().time.toString();
        _loader.addEventListener(BulkLoader.COMPLETE, onAllLoaded);
        _loader.addEventListener(BulkLoader.ERROR, onErrorLoad);
    }

    private function onErrorLoad(event:Event):void
    {
        var type:String = "IO";
        if (event is SecurityErrorEvent) type = "Security";
        Cc.log("error load configs - " + type + "Error");

        dispatchEvent(new CoreEvent(CoreEvent.CONFIG_LOAD_ERROR, true));
    }

    private function onAllLoaded(event:Event):void
    {
        try
        {
            var objects:String = _loader.getText(OBJ_IDENTIFIER);
            Constants._config = YAML.decode(objects);
            dispatchEvent(new CoreEvent(CoreEvent.CONFIG_LOADED, true));
        } catch (e:*)
        {
            Cc.log("error parce configs");
        }
    }

    public function loadConfigs():void
    {
        _loader.add(_path, {id:OBJ_IDENTIFIER});
        _loader.start();

    }
}
}
