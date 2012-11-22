package
{

import core.EntryPoint;

import debug.Console;

import flash.display.Sprite;
import flash.events.Event;
import flash.system.Security;

[SWF(width='800', height='600', backgroundColor='#ffffff', frameRate='30')]
public class Main extends Sprite
{

    public function Main()
    {
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

}
}
