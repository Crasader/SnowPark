/**
 * Author: JuzTosS
 * Date: 10.06.12
 */
package net
{
import com.junkbyte.console.Cc;

import config.Constants;

import flash.events.EventDispatcher;

import net.ServerAPI.JSSConnection;
import net.ServerAPI.JSSEvent;

public class ServerConnection extends EventDispatcher
{
    private static var _inst:ServerConnection;

    private var _jss:JSSConnection;
    private var _connected:Boolean = false;
    private var _connecting:Boolean = false;

    private var _postponed_requests:Array = [];

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

    private function send_postponed_requests():void
    {
        var request:Array = _postponed_requests.shift();
        if (request)
            send_request(request);
    }

    private function handleReceiveData(event:JSSEvent):void
    {
        dispatchEvent(new ServerConnectionEvent(ServerConnectionEvent.REQUEST_RECEIVED, event.data));
        send_postponed_requests();
    }

    public static function get inst():ServerConnection
    {
        if (!_inst) _inst = new ServerConnection();
        return _inst;
    }

    public function send(command_id:int, command_params:Array):void
    {
        var request:Array = [command_id, command_params];
        if (!_connected)
        {
            if (!_connecting)
            {
                _connecting = true;
                connect();
            }
            _postponed_requests.push(request);
            return;
        }

        send_request(request);
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
