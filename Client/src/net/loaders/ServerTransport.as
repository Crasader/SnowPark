/**
 * Author: JuzTosS
 * Date: 10.06.12
 */
package net.loaders
{
import com.junkbyte.console.Cc;

import config.Constants;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;

public class ServerTransport extends EventDispatcher
{
    private var _loader:URLLoader = new URLLoader();

    public function ServerTransport()
    {
        _loader.addEventListener(Event.COMPLETE, handleReceiveData);
        _loader.addEventListener(IOErrorEvent.IO_ERROR, handleError);
        _loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleError);
    }

    private function handleError(event:Event):void
    {
        if (event is IOErrorEvent)
            Cc.error("IO Error! " + (event as IOErrorEvent).text);
        if (event is SecurityErrorEvent)
            Cc.error("Security Error! " + (event as SecurityErrorEvent).text);

        dispatchEvent(new ServerTransportEvent(ServerTransportEvent.ERROR, event));
    }

    private function handleReceiveData(event:Event):void
    {
        dispatchEvent(new ServerTransportEvent(ServerTransportEvent.RESPONSE, _loader.data));
    }

    public function send(data:String):void
    {
        var request:URLRequest = new URLRequest(Constants.SERVER_URL);
        request.method = URLRequestMethod.POST;

        var vars:URLVariables = new URLVariables();
        vars["data"] = data;
        request.data = vars;

        _loader.load(request);
    }
}
}
