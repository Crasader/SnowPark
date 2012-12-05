package
{

import core.EntryPoint;

import debug.Console;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.system.Security;

[SWF(width='800', height='600', backgroundColor='#ffffff', frameRate='30')]
public class Main extends Sprite
{
    private static var _globalErrorDispathcer:IEventDispatcher;

    public function Main()
    {
        _globalErrorDispathcer = loaderInfo.uncaughtErrorEvents;

        Security.allowDomain("*");
        if (stage)
            init();
        else
            addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(event:Event = null):void
    {
        removeEventListener(Event.ADDED_TO_STAGE, init);

        Console.init(stage);
        var entryPoint:EntryPoint = new EntryPoint();
        addChild(entryPoint);
    }

    public static function get globalErrorDispatcher():IEventDispatcher
    {
        return _globalErrorDispathcer;
    }

}
}
