/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 23.03.12
 * Time: 19:36
 * To change this template use File | Settings | File Templates.
 */
package controllers
{
import basemvc.controller.CompositeController;

import com.junkbyte.console.Cc;

import config.ConfigLoader;
import config.Constants;

import events.CommandEvent;
import events.CoreEvent;

import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

import misc.AppSettings;

import net.NetController;
import net.NetControllerEvent;

public class CoreController extends CompositeController
{
    private var _node:DisplayObjectContainer;

    private var _userController:UserController;
    private var _configLoader:ConfigLoader;
    private var _serverTransport:NetController;

    private var _worldTimer:Timer;
    private var _lastTickTime:Number;
    private var _lastFrameTime:Number;

    private var _api:SocWrapper;

    public function CoreController(node:DisplayObjectContainer)
    {
        super();

        _node = node;

        _configLoader = new ConfigLoader();
        add(_configLoader);

        _configLoader.addEventListener(CoreEvent.CONFIG_LOADED, onConfigLoaded);
        _configLoader.addEventListener(CoreEvent.CONFIG_LOAD_ERROR, onConfigLoadError);
        _configLoader.loadConfigs();
    }

    private function onConfigLoadError(event:CoreEvent):void
    {
        Cc.log("Retry laod configs...");
    }

    private function onConfigLoaded(event:CoreEvent):void
    {
        Cc.log("Configs loaded!");
        _userController = new UserController(_node);
        add(_userController);

        addEventListener(CommandEvent.SEND_COMMAND, onSendCommand);

        startWorldTimer();
        _lastFrameTime = new Date().time;
        _node.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);

        var settings:AppSettings = new AppSettings();
        settings.accessFriends = true;
        _api = new SocWrapper();

        _api.addEventListener(SocWrapperEvent.USER_LOADED, function (e:Event):void
        {
            Cc.log("user Loaded");
            dispatchEvent(new CommandEvent("getUserData", {}, true));
        });
        _api.addEventListener(SocWrapperEvent.FRIENDS_LOADED, function (e:Event):void
        {
            Cc.log("friends Loaded");
        });

        _api.initialize(_node, SocWrapper.LOCAL, settings);
        _serverTransport = new NetController();
        _serverTransport.addEventListener(NetControllerEvent.RESPONSE, onResponse);
        _serverTransport.initialize({authKey:_api.authKey, apiId:_api.apiId, viewerId:_api.getUser().id});
        _api.loadBaseInformation();
    }

    private function onEnterFrame(event:Event):void
    {
        var now:Number = new Date().time;
        var dt:Number = now - _lastFrameTime;
        _lastFrameTime = now;

        var e:CoreEvent = new CoreEvent(CoreEvent.ENTER_FRAME);
        e.data = dt;
        dispatchEvent(e);
    }

    private function startWorldTimer():void
    {
        if (_worldTimer)
        {
            _worldTimer.removeEventListener(TimerEvent.TIMER, onTick);
            _worldTimer.stop();
        }

        _lastTickTime = new Date().time;
        _worldTimer = new Timer(Constants.WORLD_TIMER_INTERVAL);
        _worldTimer.addEventListener(TimerEvent.TIMER, onTick);
        _worldTimer.start();
    }

    private function onTick(event:TimerEvent):void
    {
        var now:Number = new Date().time;
        var dt:Number = now - _lastTickTime;
        _lastTickTime = now;
        var e:CoreEvent = new CoreEvent(CoreEvent.WORLD_TICK);
        e.data = dt;
        dispatchEvent(e);
    }

    private function onResponse(event:NetControllerEvent):void
    {
        try
        {
            var responseData:String = event.data;
            Cc.log("response: " + event.data);
//            dispatchEvent(new ResponseEvent(commandId, responseParams))
        } catch (e:Error)
        {
            Cc.log("invalid response!");
        }
    }

    private function onSendCommand(e:CommandEvent):void
    {
        _serverTransport.send(e.commandName, e.commandParams, e.forceSend);
    }
}
}
