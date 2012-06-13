package net.ServerAPI
{

import com.junkbyte.console.Cc;

import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.ObjectEncoding;
import flash.net.Socket;

public class JSSConnection
{

    private var _debug:Boolean;
    private var _dispatcher:IEventDispatcher;

    private var _host:String;
    private var _port:int;
    private var _socket:Socket;

    private var _isConnected:Boolean;

    public function JSSConnection(dispatcher:IEventDispatcher, debug:Boolean = false)
    {
        _dispatcher = dispatcher;
        _debug = debug;

        createSocketAndAddHandlers();
    }

    private function createSocketAndAddHandlers():void
    {
        _socket = new Socket();
        _socket.addEventListener(Event.CONNECT, handleSocketConnect);
        _socket.addEventListener(Event.CLOSE, handleSocketClose);
        _socket.addEventListener(IOErrorEvent.IO_ERROR, handleSocketError);
        _socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
        _socket.addEventListener(ProgressEvent.SOCKET_DATA, handleSocketData);
    }

    public function connect(host:String, port:int):void
    {
        _host = host;
        _port = port;

        try
        {
            Cc.log("Connect to " + _host + ":" + _port);
            _socket.connect(_host, _port);
        } catch (error:SecurityError)
        {
            Cc.log("Security error: " + error);
            _dispatcher.dispatchEvent(new JSSEvent(JSSEvent.SECURITY_ERROR, error.toString()));
        } catch (error:Error)
        {
            Cc.log("Connection error: " + error);
        }
    }

    private function handleSocketConnect(event:Event):void
    {
        _isConnected = true;
        _dispatcher.dispatchEvent(new JSSEvent(JSSEvent.CONNECT_TO_SERVER_SOCKET))
    }

    public function disconnect(reason:String):void
    {
        try
        {
            if (_socket != null)
            {
                _socket.close();
            }
        } catch (error:Error)
        {
            Cc.log("Socket not connected:" + error.message);
        }
        dispatchConnectionLost(reason);
    }

    private function handleSocketClose(event:Event):void
    {
        dispatchConnectionLost(JSSClientDisconnectionReason.SOCKET_CLOSE);
    }

    private function dispatchConnectionLost(reason:String):void
    {
        _isConnected = false;
        _dispatcher.dispatchEvent(new JSSEvent(JSSEvent.CONNECTION_LOST, reason));
    }

    private function handleSocketData(event:ProgressEvent):void
    {
        receiveObject(_socket.readObject());
    }

    private function handleSocketError(event:IOErrorEvent):void
    {
        _dispatcher.dispatchEvent(new JSSEvent(JSSEvent.SOCKET_ERROR));
    }

    private function handleSecurityError(event:SecurityErrorEvent):void
    {
        _dispatcher.dispatchEvent(new JSSEvent(JSSEvent.SECURITY_ERROR, event.toString()));
    }

    public function sendObject(obj:*):void
    {
        if (_socket != null && _socket.connected)
        {
            try
            {
                _socket.objectEncoding = ObjectEncoding.AMF3;
                _socket.writeObject(obj);
                _socket.flush();

            } catch (error:Error)
            {
                Cc.log("Error sending data: " + error);
            }

        } else
        {
            if (_isConnected)
            {
                dispatchConnectionLost(JSSClientDisconnectionReason.SOCKED_CONNECTED_FAIL);
            } else
            {
                Cc.log("Error sending request without connection");
            }
        }
    }

    private function receiveObject(obj:*):void
    {
        _dispatcher.dispatchEvent(new JSSEvent(JSSEvent.RECEIVE_DATA, obj));
    }

    //noinspection JSUnusedGlobalSymbols
    public function get host():String
    {
        return _host;
    }

    //noinspection JSUnusedGlobalSymbols
    public function get port():int
    {
        return _port;
    }

    //noinspection JSUnusedGlobalSymbols
    public function isConnect():Boolean
    {
        return _socket != null && _socket.connected;
    }

}
}