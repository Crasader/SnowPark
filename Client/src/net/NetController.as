/**
 * Author: JuzTosS
 * Date: 19.11.12
 */
package net
{
import com.junkbyte.console.Cc;

import config.Constants;

import flash.events.EventDispatcher;
import flash.events.TimerEvent;
import flash.utils.Timer;

import net.loaders.ServerTransport;
import net.loaders.ServerTransportEvent;

public class NetController extends EventDispatcher
{
    private var _updateTimer:Timer = new Timer(Constants.SEND_REQUESTS_INTERVAL);
    private var _commandBuffer:Array = [];
    private var _errorCommandBuffer:Array = [];
    private var _transport:ServerTransport = new ServerTransport();

    private var _defaultMessageParams:Object;

    public function NetController()
    {
        _transport.addEventListener(ServerTransportEvent.RESPONSE, onResponse);
        _transport.addEventListener(ServerTransportEvent.ERROR, onError);

        _updateTimer.addEventListener(TimerEvent.TIMER, sendRequest);
        _updateTimer.start();
    }

    private function sendRequest(event:TimerEvent = null):void
    {
        if (_commandBuffer.length <= 0) return;

        _errorCommandBuffer = _commandBuffer.concat();

        var data:Object = {queue:_commandBuffer};
        for (var key:String in _defaultMessageParams)
        {
            data[key] = _defaultMessageParams[key];
        }

        var dataJSON:String = JSON.stringify(data);

        _transport.send(dataJSON);
        _commandBuffer.length = 0;
    }

    private function onError(event:ServerTransportEvent):void
    {
        _commandBuffer = _errorCommandBuffer.concat(_commandBuffer);
        dispatchEvent(new NetControllerEvent(NetControllerEvent.ERROR));
        Cc.error("Server transport error!");
    }

    private function onResponse(event:ServerTransportEvent):void
    {
        var stringData:String = event._data;
        dispatchEvent(new NetControllerEvent(NetControllerEvent.RESPONSE, stringData));
    }

    public function send(cmd:String, params:Object, force:Boolean):void
    {
        Cc.log("in queue: " + cmd + ", " + params.toString());

        _commandBuffer.push({cmd:cmd, params:params});
        if (force) sendRequest();
    }

    public function initialize(defaultMessageParams:Object):void
    {
        _defaultMessageParams = defaultMessageParams;
    }
}
}
