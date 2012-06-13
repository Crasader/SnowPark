/**
 * Author: JuzTosS
 * Date: 31.05.12
 */
package
{
import connectors.IAPIConnector;
import connectors.LocalConnector;
import vk_connector.VKAPIConnector;

import flash.display.DisplayObjectContainer;
import flash.events.EventDispatcher;

import misc.SUser;

public class SocWrapper extends EventDispatcher
{
    private static const _connectors:Array = [LocalConnector, VKAPIConnector];
    public static const LOCAL:int = 0;
    public static const VKONTAKTE:int = 1;

    private var _api:IAPIConnector;

    public function SocWrapper(stage_inst:DisplayObjectContainer, connector_type:int)
    {
        _api = new _connectors[connector_type]();
        _api.init(stage_inst);
    }

    public function getUser():SUser
    {
        return null;
    }

    public function getFriends():Array
    {
        return null;
    }

    public function sendAppNotification(user:SUser):void
    {

    }

    public function sendMessageToWall(user:SUser):void
    {

    }

    public function inviteUser(user:SUser = null):void
    {

    }

    public function openPaymentWindow(votes:int = 0):void
    {

    }
}
}
