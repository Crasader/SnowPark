/**
 * Author: JuzTosS
 * Date: 31.05.12
 */
package connectors
{
import flash.events.EventDispatcher;

import misc.AppSettings;
import misc.SUser;

public class LocalConnector extends EventDispatcher implements IAPIConnector
{
    private var _allUsers:Array = [];
    private var _viewer:SUser;
    private var _userSettings:AppSettings;
    private static const VIEWER_ID:String = "LOCAL_VIEWER";
    private static const NUM_OF_FRIENDS:int = 5;

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
        return VIEWER_ID;
    }

    public function get posterId():String
    {
        return "1";
    }

    public function get authKey():String
    {
        return "42f32af339f0fa4aa8035f97ed3f8271";
    }

    public function currencyForms():Array
    {
        return ["У.Е.", "У.Е.", "У.Е."];
    }

    public function set onBalanceChanged(callback:Function):void
    {
    }

    public function init(...__rest):void
    {
        _viewer = new SUser();

        _viewer.birthdate = new Date(1988, 7, 3);
        _viewer.first_name = "Кирилл";
        _viewer.last_name = "Ахметов";
        _viewer.id = VIEWER_ID;
        _viewer.nickname = "JuzTosS";
        _viewer.sex = SUser.SEX_MALE;

        for (var i:int = 0; i < NUM_OF_FRIENDS; i++)
        {
            var user:SUser = new SUser();
            user.birthdate = new Date(1987, 11, 8);
            user.first_name = "Друг";
            user.last_name = "Хороший";
            user.id = i.toString();
            user.nickname = "MegaFriend";
            user.sex = SUser.SEX_MALE;
            _allUsers.push(user);
        }

        _userSettings = new AppSettings();
        _userSettings.accessAds = true;
        _userSettings.accessAudio = true;
        _userSettings.accessDocuments = true;
        _userSettings.accessFriends = true;
        _userSettings.accessGroups = true;
        _userSettings.accessNotes = true;
        _userSettings.accessPhotos = true;
        _userSettings.accessProposals = true;
        _userSettings.accessQuestions = true;
        _userSettings.accessStatuses = true;
        _userSettings.accessVideo = true;
        _userSettings.accessWall = true;
        _userSettings.accessWiki = true;
        _userSettings.allowNotifications = true;
        _userSettings.fastLink = true;
        _userSettings.leftMenuLink = true;
    }

    public function showSetup(settings:AppSettings):void
    {
        dispatchEvent(new SocWrapperEvent(SocWrapperEvent.SETTINGS_CHANGED));
    }

    public function showInviteBox(cb:Function = null, ids:Array = null):void
    {
    }

    public function showPaymentBox(typeTr:String, param:String):void
    {
    }

    public function getProfiles(ids:Array, cb:Function):void
    {
        var res:Array = [];
        for each(var user:SUser in _allUsers)
        {
            if (ids.indexOf(user.id) >= 0)
                res.push(user);
        }

        if (ids.indexOf(VIEWER_ID) >= 0)
            res.push(_viewer);

        cb(res);
    }

    public function getFriends(userId:String, cb:Function):void
    {
        cb(_allUsers);
    }

    public function isMemberOfGroup(userId:String, groupId:String, cb:Function):void
    {
    }

    public function getUserSettings(cb:Function):void
    {
        cb(_userSettings);
    }

    public function get appInstalled():Boolean
    {
        return true;
    }

}
}
