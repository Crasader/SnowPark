/**
 * Author: JuzTosS
 * Date: 20.11.12
 */
package connectors
{
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.EventDispatcher;

import misc.AppSettings;
import misc.SUser;

import vk.APIConnection;

public class VKConnector extends EventDispatcher implements IAPIConnector
{
    private var _parameters:Object;
    private var _onBalanceChanged:Function;
    private var _connection:APIConnection;

    private static const FIELDS:String = "uid, first_name, last_name," +
            " nickname, sex, bdate," +
            " city, country, photo, photo_medium," +
            " photo_big";

    //stage, flashVars
    public function init(...__rest):void
    {

        if (__rest.length < 2)
        {
            throw(new Error("Invalid init params"));
            return;
        }

        var container:DisplayObjectContainer = __rest[0];
        var params:Object = __rest[1];
        _connection = new APIConnection(params);
        _parameters = params;

        _connection.addEventListener("onSettingsChanged", onSettingsChanged);
    }

    private function onSettingsChanged(event:Event):void
    {
        dispatchEvent(new SocWrapperEvent(SocWrapperEvent.SETTINGS_CHANGED));
    }

    public function get authKey():String
    {
        return parameters["auth_key"];
    }

    public function get inviterId():String
    {
        return parameters["user_id"];
    }

    public function get viewerId():String
    {
        return parameters["viewer_id"];
    }

    public function get advId():String
    {
        return parameters["referrer"];
    }

    public function get posterId():String
    {
        return parameters["poster_id"];
    }

    public function get apiId():String
    {
        return parameters["api_id"];
    }

    public function set onBalanceChanged(callback:Function):void
    {
        _onBalanceChanged = callback;
        if (_onBalanceChanged != null)
            _connection.removeEventListener('onBalanceChanged', _onBalanceChanged);
        if (callback != null)
        {
            _onBalanceChanged = callback;
            _connection.addEventListener('onBalanceChanged', _onBalanceChanged);
        }
    }

    public function currencyForms():Array
    {
        return ['голос', 'голоса', 'голосов'];
    }

    public function get parameters():Object
    {
        if (!_parameters) return {};
        return _parameters;
    }

    public function showSetup(settings:AppSettings):void
    {
        _connection.callMethod("showSettingsBox", getSerializedSettings(settings));
    }

    public function showInviteBox(cb:Function = null, ids:Array = null):void
    {
        _connection.callMethod("showInviteBox");
    }

    public function showPaymentBox(votes:uint = 0):void
    {
        _connection.callMethod("showPaymentBox", votes);
    }

    public function getProfiles(ids:Array, cb:Function):void
    {
        var uids:String = "";
        for each(var id:String in ids)
            uids += id + ",";

        uids = uids.slice(0, uids.length - 1);

        _connection.api('users.get', {uids:uids, fields:FIELDS}, usersLoaded, onError);

        function usersLoaded(res:Object):void
        {
            var users:Array = fillProfiles(res);
            cb(users);
        }
    }

    public function getFriends(userId:String, cb:Function):void
    {
        _connection.api('friends.get', {uid:userId, fields:FIELDS}, usersLoaded, onError);

        function usersLoaded(res:Object):void
        {
            var users:Array = fillProfiles(res);
            cb(users);
        }
    }

    private function fillProfiles(res:Object):Array
    {
        var users:Array = [];
        for each(var userObj:Object in res)
        {
            var user:SUser = new SUser();

            user.avatar_pic = userObj.photo;
            user.birthdate = stringToDate(userObj.bdate);
            user.city = userObj.city;
            user.country = userObj.country;
            user.first_name = userObj.first_name;
            user.id = userObj.uid;
            user.last_name = userObj.last_name;
            user.nickname = userObj.nickname;
            user.photo_big = userObj.photo_big;
            user.photo_medium = userObj.photo_medium;
            user.sex = userObj.sex;

            users.push(user);
        }

        return users;
    }

    public function isMemberOfGroup(userId:String, groupId:String, cb:Function):void
    {
    }

    public function getUserSettings(cb:Function):void
    {
        _connection.api('getUserSettings', {uid:viewerId}, getSettings, onError);

        function getSettings(e:Object):void
        {
            cb(getDeserializedSettings(int(e)));
        }
    }

    public function get appInstalled():Boolean
    {
        return false;
    }

    public function getSerializedSettings(settings:AppSettings):int
    {
        var sSettings:int = 0;

        if (settings.allowNotifications)
            sSettings = sSettings | 1;
        if (settings.accessFriends)
            sSettings = sSettings | 2;
        if (settings.accessPhotos)
            sSettings = sSettings | 4;
        if (settings.accessAudio)
            sSettings = sSettings | 8;
        if (settings.accessVideo)
            sSettings = sSettings | 16;
        if (settings.accessProposals)
            sSettings = sSettings | 32;
        if (settings.accessQuestions)
            sSettings = sSettings | 64;
        if (settings.accessWiki)
            sSettings = sSettings | 128;
        if (settings.leftMenuLink)
            sSettings = sSettings | 256;
        if (settings.fastLink)
            sSettings = sSettings | 512;
        if (settings.accessStatuses)
            sSettings = sSettings | 1024;
        if (settings.accessNotes)
            sSettings = sSettings | 2048;
//        if(settings.advanced)
//            sSettings = sSettings | 4096;
        if (settings.accessWall)
            sSettings = sSettings | 8192;
        if (settings.accessAds)
            sSettings = sSettings | 32768;
        if (settings.accessDocuments)
            sSettings = sSettings | 131072;
        if (settings.accessGroups)
            sSettings = sSettings | 262144;

        return sSettings;
    }

    public function getDeserializedSettings(settings:int):AppSettings
    {
        var appSettings:AppSettings = new AppSettings();

        if (settings & 1)
            appSettings.allowNotifications = true;
        if (settings & 2)
            appSettings.accessFriends = true;
        if (settings & 4)
            appSettings.accessPhotos = true;
        if (settings & 8)
            appSettings.accessAudio = true;
        if (settings & 16)
            appSettings.accessVideo = true;
        if (settings & 32)
            appSettings.accessProposals = true;
        if (settings & 64)
            appSettings.accessQuestions = true;
        if (settings & 128)
            appSettings.accessWiki = true;
        if (settings & 256)
            appSettings.leftMenuLink = true;
        if (settings & 512)
            appSettings.fastLink = true;
        if (settings & 1024)
            appSettings.accessStatuses = true;
        if (settings & 2048)
            appSettings.accessNotes = true;
//        if(settings & 4096)
//            appSettings.advanced = true;
        if (settings & 8192)
            appSettings.accessWall = true;
        if (settings & 32768)
            appSettings.accessAds = true;
        if (settings & 131072)
            appSettings.accessDocuments = true;
        if (settings & 262144)
            appSettings.accessGroups = true;

        return appSettings;

    }

    private function onError(e:Object):void
    {
        var output:String = "";
        for each(var e_text:String in e)
            output += e_text;

        throw(new Error(output));
    }

    private function stringToDate(date:String):Date
    {
        var dates:Array = date.split(".");
        return new Date(dates[2], dates[1], dates[0]);
    }
}
}
