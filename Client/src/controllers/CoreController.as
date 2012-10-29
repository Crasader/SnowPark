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

import controllers.events.CMDList;

import controllers.events.CommandEvent;
import controllers.events.ResponseEvent;

import flash.display.DisplayObjectContainer;

import mx.binding.utils.BindingUtils;

import net.ServerConnection;
import net.ServerConnectionEvent;

public class CoreController extends CompositeController
{

    private var _instanse:CoreController;

    private var _command_queue:Array = [];

    private var _user_controller:UserController;

    public function CoreController(node:DisplayObjectContainer)
    {
        if (_instanse == null)
        {
            _instanse = this;
            _core = this;
        }
        else
        {
            throw "can't create CoreController";
        }

        _user_controller = new UserController(node);
        add(_user_controller);

        BindingUtils.bindSetter(on_auth, _user_controller.getModel(), "_auth_passed");
        addEventListener(CommandEvent.SNOW_COMMAND, on_send_command);
        ServerConnection.inst.addEventListener(ServerConnectionEvent.REQUEST_RECEIVED, on_receive_request);
    }

    private function on_auth(passed:Boolean):void
    {
        if (passed)
            send_postponed_commands();
    }

    private function send_postponed_commands():void
    {
        for (var i:int = _command_queue.length - 1; i >= 0; i--)
            send_command(_command_queue[i]);

        _command_queue.length = 0;
    }

    private function on_receive_request(event:ServerConnectionEvent):void
    {

        try
        {
            var response_data:Array = event._data;

            var command_id:int = response_data[0];
            var response_params:Array = response_data[1];

            Cc.log("receive response : " + command_id + " : " + response_params);

            dispatchEvent(new ResponseEvent(command_id, response_params))
        } catch (e:Error)
        {
            Cc.log("invalid response!");
        }
    }

    private function on_send_command(e:CommandEvent):void
    {
        if (_user_controller.getModel()._auth_passed
                || e.command_id == CMDList.AUTH
                || e.command_id == CMDList.CREATE_USER)
            send_command(e);
        else
            _command_queue.push(e);
    }

    private function send_command(e:CommandEvent):void
    {
        ServerConnection.inst.send(e.command_id, e.command_params, e.force_send);
    }

}
}
