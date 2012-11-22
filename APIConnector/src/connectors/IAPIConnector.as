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

    function get fakeViewerId():String;

    function get authKey():String;

    function set onBalanceChanged(callback:Function):void;

    function init(...__rest):void;

    function showSetup(mask:int):void;

    function showInviteBox(cb:Function = null, ids:Array = null):void;

    function showPaymentBox(votes:uint = 0):void;

    function getProfiles(ids:Array, cb:Function, fields:String, er:Function = null):void;

    function getFriends(userId:String, fields:String, cb:Function = null, er:Function = null):void;

    function get currencyForms():Array;

    function firstRequest(command:Object):void;

    function isMemberOfGroup(groupId:String, cb:Function, userId:String = null):void;

    function getUserSettings(cb:Function = null, er:Function = null):void;

    function get appInstalled():Boolean;

    function getSerializedSettings(settings:AppSettings):int;

    function getDeserializedSettings(settings:int):AppSettings;
}
}