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

    private var _postponed_requests:Array = [];

    private var _timer:Timer;

    public function ServerConnection()
    {
    }

    public function connect():void
    {
        _jss = new JSSConnection(this, true);
        addEventListener(JSSEvent.CONNECT_TO_SERVER_SOCKET, handleConnect);
        addEventListener(JSSEvent.RECEIVE_DATA, handleReceiveData);
        addEventListener(JSSEvent.CONNECTION_LOST, hadleConnectionLost);

        _jss.connect(Constants.SERVER_IP, Constants.SERVER_PORT);

        init_requests_timer();
    }

    private function init_requests_timer():void
    {
        _timer = new Timer(Constants.SEND_REQUESTS_INTERVAL);
        _timer.addEventListener(TimerEvent.TIMER, send_postponed_requests);
        _timer.start();
    }

    private function hadleConnectionLost(event:JSSEvent):void
    {
        _connected = false;
        _connecting = false;
    }

    private function handleConnect(event:JSSEvent):void
    {
        _connected = true;
        _connecting = false;
        send_postponed_requests();
    }

    private function send_postponed_requests(e:Event = null):void
    {
        safe_connect();
        if (!_connected) return;

        for (var i:int = _postponed_requests.length - 1; i >= 0; i--)
            send_request(_postponed_requests[i]);

        _postponed_requests.length = 0;
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

    public function send(command_id:int, command_params:Array, force:Boolean = false):void
    {
        var request:Array = [command_id, command_params];
        _postponed_requests.push(request);
        if(_postponed_requests.length >= Constants.MAX_NUM_OF_REQUESTS || force)
            send_postponed_requests();

        return;
    }

    private function safe_connect():void
    {
        if (!_connecting && !_connected)
        {
            _connecting = true;
            connect();
        }
    }

    private function send_request(request:Array):void
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
