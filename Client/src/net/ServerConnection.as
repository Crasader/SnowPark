/**
 * Author: JuzTosS
 * Date: 10.06.12
 */
package net
{
import com.junkbyte.console.Cc;

import config.Constants;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.TimerEvent;
import flash.utils.Timer;

import net.ServerAPI.JSSConnection;
import net.ServerAPI.JSSEvent;

public class ServerConnection extends EventDispatcher
{
    private static var _inst:ServerConnection;

    private var _jss:JSSConnection;
    private var _connected:Boolean = false;
    private var _connecting:Boolean = false;

    private var _postponedRequests:Array = [];

    private var _timer:Timer;

    public function ServerConnection()
    {
        _jss = new JSSConnection(this, true);
        addEventListener(JSSEvent.CONNECT_TO_SERVER_SOCKET, handleConnect);
        addEventListener(JSSEvent.RECEIVE_DATA, handleReceiveData);
        addEventListener(JSSEvent.CONNECTION_LOST, hadleConnectionLost);
        addEventListener(JSSEvent.SOCKET_ERROR, hadleConnectionLost);

        initRequestsTimer();
    }

    public function connect():void
    {
        _jss.connect(Constants.SERVER_IP, Constants.SERVER_PORT);

    }

    private function initRequestsTimer():void
    {
        _timer = new Timer(Constants.SEND_REQUESTS_INTERVAL);
        _timer.addEventListener(TimerEvent.TIMER, sendPostponedRequests);
        _timer.start();
    }

    private function hadleConnectionLost(event:JSSEvent):void
    {
        Cc.log("/!\\ Connection failed /!\\");
        _connected = false;
        _connecting = false;
    }

    private function handleConnect(event:JSSEvent):void
    {
        Cc.log("Connected.");
        _connected = true;
        _connecting = false;
        sendPostponedRequests();
    }

    private function sendPostponedRequests(e:Event = null):void
    {
        safeConnect();
        if (!_connected) return;

        for (var i:int = _postponedRequests.length - 1; i >= 0; i--)
            sendRequest(_postponedRequests[i]);

        _postponedRequests.length = 0;
    }

    private function handleReceiveData(event:JSSEvent):void
    {
        dispatchEvent(new ServerConnectionEvent(ServerConnectionEvent.REQUEST_RECEIVED, event.data));
    }

    public static function get inst():ServerConnection
    {
        if (!_inst) _inst = new ServerConnection();
        return _inst;
    }

    public function send(commandId:int, commandParams:Array, force:Boolean = false):void
    {
        var request:Array = [commandId, commandParams];
        _postponedRequests.push(request);
        if (_postponedRequests.length >= Constants.MAX_NUM_OF_REQUESTS || force)
            sendPostponedRequests();

        return;
    }

    private function safeConnect():void
    {
        if (!_connecting && !_connected)
        {
            _connecting = true;
            connect();
        }
    }

    private function sendRequest(request:Array):void
    {
        try
        {
            Cc.log("send request : " + request[0] + " : " + request[1]);
        } catch (e:*)
        {
            Cc.error("Try send invalid request!");
        }
        _jss.sendObject(request);
    }
}
}
