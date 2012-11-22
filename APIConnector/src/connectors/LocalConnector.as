/**
 * Author: JuzTosS
 * Date: 31.05.12
 */
package connectors
{
import flash.events.EventDispatcher;

import misc.AppSettings;

public class LocalConnector extends EventDispatcher implements IAPIConnector
{
    public function get parameters():Object
    {
        return null;
    }

    public function get apiId():String
    {
        return "1";
    }

    public function get advId():String
    {
        return "1";
    }

    public function get inviterId():String
    {
        return "1";
    }

    public function get viewerId():String
    {
        return "1";
    }

    public function get posterId():String
    {
        return "1";
    }

    public function get fakeViewerId():String
    {
        return "1";
    }

    public function get authKey():String
    {
        return "1";
    }

    public function set onBalanceChanged(callback:Function):void
    {

    }

    public function init(...__rest):void
    {
    }

    public function showSetup(mask:int):void
    {
    }

    public function showInviteBox(cb:Function = null, ids:Array = null):void
    {
    }

    public function showPaymentBox(votes:uint = 0):void
    {
    }

    public function getProfiles(ids:Array, cb:Function, fields:String, er:Function = null):void
    {
    }

    public function getFriends(listing:String, fields:String, cb:Function = null, er:Function = null):void
    {
    }

    public function get currencyForms():Array
    {
        return ["У.Е.", "У.Е.", "У.Е."];
    }

    public function firstRequest(command:Object):void
    {
    }

    public function isMemberOfGroup(groupId:String, cb:Function, userId:String = null):void
    {
    }

    public function getUserSettings(cb:Function = null, er:Function = null):void
    {
    }

    public function get appInstalled():Boolean
    {
        return true;
    }

    public function getSerializedSettings(settings:AppSettings):int
    {
        return 0;
    }

    public function getDeserializedSettings(settings:int):AppSettings
    {
        return null;
    }
}
}
