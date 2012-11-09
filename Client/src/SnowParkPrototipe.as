package
{

import config.Constants;

import core.EntryPoint;

import debug.Console;

import flash.display.Sprite;
import flash.events.Event;
import flash.system.Security;

[SWF(width='800', height='600', backgroundColor='#ffffff', frameRate='30')]
public class SnowParkPrototipe extends Sprite
{


    public function SnowParkPrototipe()
    {

        if (stage)
            init();
        else
            addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(event:Event = null):void
    {
        removeEventListener(Event.ADDED_TO_STAGE, init);

        Security.allowDomain("*");
        Console.init(stage);
        var entryPoint:EntryPoint = new EntryPoint();
        addChild(entryPoint);
    }

}
}
