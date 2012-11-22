package
{

import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.net.URLRequest;
import flash.system.Security;
import flash.text.TextField;

public class Main extends Sprite
{
    private var _contentLoader:Loader = new Loader();

    private var _textPrc:TextField = new TextField();

    public function Main()
    {
        Security.allowDomain("*");
        initLoader();
        addChild(_textPrc);
        _contentLoader.load(new URLRequest("http://localhost/snow/SnowParkClient.swf"));
    }

    private function initLoader():void
    {
        _contentLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, updatePreloader);
        _contentLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
    }

    private function onLoadComplete(event:Event):void
    {
        _contentLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, updatePreloader);
        _contentLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
        addChild(_contentLoader.content);
        removeChild(_textPrc);
    }

    private function updatePreloader(event:ProgressEvent):void
    {
        _textPrc.text = (event.bytesLoaded / event.bytesTotal * 100).toString() + "%";
    }
}
}
