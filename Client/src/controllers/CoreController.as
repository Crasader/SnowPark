/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 23.03.12
 * Time: 19:36
 * To change this template use File | Settings | File Templates.
 */
package controllers
{
import basemvc.compose.CompositeObject;
import basemvc.controller.CompositeController;

import com.junkbyte.console.Cc;

import controllers.events.CommandEvent;
import controllers.events.ResponseEvent;

import flash.display.DisplayObjectContainer;

import net.ServerConnection;

import net.ServerConnectionEvent;

import net.ServerConnection;

public class CoreController extends CompositeController
{

    private var _instanse:CoreController;
    
    public function CoreController(node:DisplayObjectContainer)
    {
        if(_instanse == null)
        {
            _instanse = this;
            _core = this;
        }
        else
        {
            throw "can't create CoreController";
        }

        var userController:UserController = new UserController(node);
        add(userController);

        addEventListener(CommandEvent.SNOW_COMMAND, on_send_command);
        ServerConnection.inst.addEventListener(ServerConnectionEvent.REQUEST_RECEIVED, on_receive_request);
    }

    private function on_receive_request(event:ServerConnectionEvent):void
    {

        try{
            var response_data:Array = event._data;

            var command_id:int = response_data[0];
            var response_params:Array = response_data[1];

            Cc.log("receive response : " + command_id + " : " + response_params);

            dispatchEvent(new ResponseEvent(command_id, response_params))
        }catch (e:Error){
            Cc.log("invalid response!");
        }
    }

    private function on_send_command(e:CommandEvent):void
    {
        Cc.log("send command : " + e.command_id + " : " + e.command_params);
        ServerConnection.inst.send(e.command_id, e.command_params);
    }

}
}
