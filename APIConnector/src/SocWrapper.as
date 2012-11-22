/**
 * Author: JuzTosS
 * Date: 31.05.12
 */
package
{
import connectors.IAPIConnector;
import connectors.LocalConnector;
import connectors.VKConnector;

import flash.display.DisplayObjectContainer;
import flash.events.EventDispatcher;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import misc.AppSettings;
import misc.SUser;

public class SocWrapper extends EventDispatcher
{
    private static const _connectors:Array = [LocalConnector, VKConnector];
    public static const LOCAL:int = 0;
    public static const VKONTAKTE:int = 1;

    private var _api:IAPIConnector;

    private var _user:SUser = new SUser();
    private var _friends:Array = [];
    private var _appSettings:AppSettings = new AppSettings();
    private var _minAppSettings:AppSettings = new AppSettings();

    public function SocWrapper(stageInst:DisplayObjectContainer, connectorType:int, settings:AppSettings)
    {
        _minAppSettings = settings;
        _api = new _connectors[connectorType]();
        _api.init(stageInst.stage, stageInst.stage.loaderInfo.parameters);
        _api.addEventListener(SocWrapperEvent.SETTINGS_CHANGED, onSettingsChanged);
        init();
    }

    private function onSettingsChanged(event:SocWrapperEvent):void
    {
        init();
    }

    private function init():void
    {
        loadUser();
        loadFriends();
    }

    private function onGetUserSettings(result:Object):void
    {
        _appSettings = _api.getDeserializedSettings(int(result));
        if (!_appSettings.minimumAccess(_minAppSettings))
        {
            _api.showSetup(_api.getSerializedSettings(_minAppSettings));
        }
    }

    private function checkSettings():void
    {
        var tId:uint = setTimeout(function ():void
        {
            _api.getUserSettings(onGetUserSettings);
            clearTimeout(tId);
        }, 3100);
    }

    private function loadFriends():void
    {
        _api.getFriends(_api.viewerId, "uid, first_name, last_name," +
                " nickname, sex, bdate," +
                " city, country, photo, photo_medium," +
                " photo_big", onFriendsLoaded, onError);
    }

    private function onError(e:Object):void
    {
        checkSettings();
    }

    private function onFriendsLoaded(res:Object):void
    {
        for each(var userObj:Object in res)
        {
            var user:SUser = new SUser();

            user.avatar_pic = userObj.photo;
            user.birthdate = userObj.bdate;
            user.city = userObj.city;
            user.country = userObj.country;
            user.first_name = userObj.first_name;
            user.id = userObj.uid;
            user.last_name = userObj.last_name;
            user.nickname = userObj.nickname;
            user.photo_big = userObj.photo_big;
            user.photo_medium = userObj.photo_medium;
            user.sex = userObj.sex;

            _friends.push(user);
        }

        dispatchEvent(new SocWrapperEvent(SocWrapperEvent.FRIENDS_LOADED));
    }

    private function loadUser():void
    {
        _user = new SUser();

        _api.getProfiles([_api.viewerId], onUserLoaded, "uid, first_name, last_name," +
                " nickname, sex, bdate," +
                " city, country, photo, photo_medium," +
                " photo_big", onError);
    }

    public function getUser():SUser
    {
        return _user;
    }

    private function onUserLoaded(res:Object):void
    {
        var userObj:Object = res[0];

        _user.avatar_pic = userObj.photo;
        _user.birthdate = stringToDate(userObj.bdate);
        _user.city = userObj.city;
        _user.country = userObj.country;
        _user.first_name = userObj.first_name;
        _user.id = userObj.uid;
        _user.last_name = userObj.last_name;
        _user.nickname = userObj.nickname;
        _user.photo_big = userObj.photo_big;
        _user.photo_medium = userObj.photo_medium;
        _user.sex = userObj.sex;

        dispatchEvent(new SocWrapperEvent(SocWrapperEvent.USER_LOADED));
    }

    private function stringToDate(date:String):Date
    {
        var dates:Array = date.split(".");
        return new Date(dates[2], dates[1], dates[0]);
    }

    public function getFriends():Array
    {
        return _friends;
    }

    public function sendAppNotification(user:SUser):void
    {

    }

    public function sendMessageToWall(user:SUser):void
    {

    }

    public function inviteUser(user:SUser = null):void
    {
        _api.showInviteBox();
    }

    public function openPaymentWindow(votes:int = 0):void
    {
        _api.showPaymentBox(votes);
    }

    public function showSettingsWindow(settings:AppSettings):void
    {
        _api.showSetup(_api.getSerializedSettings(settings));
    }

}
}
