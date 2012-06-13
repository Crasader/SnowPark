package
{

import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.net.URLRequest;
import flash.system.Security;
import flash.text.TextField;

public class PreLoader extends Sprite
{
    private var _content_loader:Loader = new Loader();

    private var _text_prc:TextField = new TextField();

    public function PreLoader()
    {
        Security.allowDomain("localhost");
        init_loader();
        addChild(_text_prc);
        _content_loader.load(new URLRequest("http://localhost/snow/SnowParkPrototipe.swf"));
    }

    private function init_loader():void
    {
        _content_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, updatePreloader);
        _content_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, on_load_complete);
    }

    private function on_load_complete(event:Event):void
    {
        _content_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, updatePreloader);
        _content_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, on_load_complete);
        addChild(_content_loader.content);
        removeChild(_text_prc);
    }

    private function updatePreloader(event:ProgressEvent):void
    {
        _text_prc.text = (event.bytesLoaded / event.bytesTotal * 100).toString() + "%";
    }
}
}
