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

    public function NetController()
    {
        _transport.addEventListener(ServerTransportEvent.RESPONSE, onResponse);
        _transport.addEventListener(ServerTransportEvent.ERROR, onError);

        _updateTimer.addEventListener(TimerEvent.TIMER, sendRequest);
        _updateTimer.start();
    }

    private function sendRequest(event:TimerEvent):void
    {
        _errorCommandBuffer = _commandBuffer.concat();
        var data:String = JSON.stringify(_commandBuffer);
        _transport.send(data);
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

    public function send(cmd:String, params:Object):void
    {
        _commandBuffer.push({cmd:cmd, params:params});
    }
}
}
