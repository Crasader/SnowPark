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

    public function SocWrapper()
    {

    }

    public function initialize(stageInst:DisplayObjectContainer, connectorType:int, settings:AppSettings):void
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

    private function onGetUserSettings(settings:AppSettings):void
    {
        if (!_appSettings.minimumAccess(_minAppSettings))
        {
            _api.showSetup(_minAppSettings);
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
        _api.getFriends(_api.viewerId, onFriendsLoaded);
    }

    private function onError(e:Object):void
    {
        checkSettings();
    }

    private function onFriendsLoaded(res:Array):void
    {
        _friends = res;
        dispatchEvent(new SocWrapperEvent(SocWrapperEvent.FRIENDS_LOADED));
    }

    private function loadUser():void
    {
        _api.getProfiles([_api.viewerId], onUserLoaded);
    }

    public function getUser():SUser
    {
        return _user;
    }

    private function onUserLoaded(res:Array):void
    {
        _user = res[0];
        dispatchEvent(new SocWrapperEvent(SocWrapperEvent.USER_LOADED));
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
        _api.showSetup(settings);
    }

}
}
