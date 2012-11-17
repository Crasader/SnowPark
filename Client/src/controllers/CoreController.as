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

import controllers.events.CommandEvent;
import controllers.events.CoreEvent;
import controllers.events.ResponseEvent;

import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

import mx.binding.utils.BindingUtils;

import net.ServerConnection;
import net.ServerConnectionEvent;
import net.spec.AUTH;
import net.spec.CREATEUSER;

public class CoreController extends CompositeController
{
    private var _node:DisplayObjectContainer;
    private var _commandQueue:Array = [];

    private var _userController:UserController;
    private var _configLoader:ConfigLoader;

    private var _worldTimer:Timer;
    private var _lastTickTime:Number;
    private var _lastFrameTime:Number;

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

        BindingUtils.bindSetter(onAuth, _userController.getModel(), "_authPassed");
        addEventListener(CommandEvent.SNOW_COMMAND, onSendCommand);
        ServerConnection.inst.addEventListener(ServerConnectionEvent.REQUEST_RECEIVED, onReceiveRequest);

        startWorldTimer();
        _lastFrameTime = new Date().time;
        _node.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
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

    private function onAuth(passed:Boolean):void
    {
        if (passed)
            sendPostponedCommands();
    }

    private function sendPostponedCommands():void
    {
        for (var i:int = _commandQueue.length - 1; i >= 0; i--)
            sendCommand(_commandQueue[i]);

        _commandQueue.length = 0;
    }

    private function onReceiveRequest(event:ServerConnectionEvent):void
    {

        try
        {
            var responseData:Array = event._data;

            var commandId:int = responseData[0];
            var responseParams:Array = responseData[1];

            Cc.log("receive response : " + commandId + " : " + responseParams);

            dispatchEvent(new ResponseEvent(commandId, responseParams))
        } catch (e:Error)
        {
            Cc.log("invalid response!");
        }
    }

    private function onSendCommand(e:CommandEvent):void
    {
        if (_userController.getModel()._authPassed
                || e.commandId == AUTH.ID
                || e.commandId == CREATEUSER.ID)
            sendCommand(e);
//        else
//            _commandQueue.push(e);
    }

    private function sendCommand(e:CommandEvent):void
    {
        ServerConnection.inst.send(e.commandId, e.commandParams, e.forceSend);
    }
}
}
