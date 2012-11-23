package connectors
{
import flash.events.IEventDispatcher;

import misc.AppSettings;

public interface IAPIConnector extends IEventDispatcher
{

    function get parameters():Object;

    function get apiId():String;

    function get advId():String;

    function get inviterId():String;

    function get viewerId():String;

    function get posterId():String;

    function get authKey():String;

    function set onBalanceChanged(callback:Function):void;

    function init(...__rest):void;

    function showSetup(settings:AppSettings):void;

    function showInviteBox(cb:Function = null, ids:Array = null):void;

    function showPaymentBox(typeTr:String, param:String):void;

    function getProfiles(ids:Array, cb:Function):void;

    function getFriends(userId:String, cb:Function):void;

    function currencyForms():Array;

    function isMemberOfGroup(userId:String, groupId:String, cb:Function):void;

    function getUserSettings(cb:Function):void;

    function get appInstalled():Boolean;
}
}