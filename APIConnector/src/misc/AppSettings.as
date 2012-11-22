/**
 * Author: JuzTosS
 * Date: 21.11.12
 */
package misc
{
public class AppSettings
{
    public var allowNotifications:Boolean = false;
    public var accessFriends:Boolean = false;
    public var accessPhotos:Boolean = false;
    public var accessAudio:Boolean = false;
    public var accessVideo:Boolean = false;
    public var accessProposals:Boolean = false;
    public var accessQuestions:Boolean = false;
    public var accessWiki:Boolean = false;
    public var leftMenuLink:Boolean = false;
    public var fastLink:Boolean = false;
    public var accessStatuses:Boolean = false;
    public var accessNotes:Boolean = false;
    public var accessWall:Boolean = false;
    public var accessAds:Boolean = false;
    public var accessDocuments:Boolean = false;
    public var accessGroups:Boolean = false;

    public function minimumAccess(min:AppSettings):Boolean
    {
        if (min.allowNotifications && !allowNotifications) return false;
        if (min.accessFriends && !accessFriends) return false;
        if (min.accessPhotos && !accessPhotos) return false;
        if (min.accessAudio && !accessAudio) return false;
        if (min.accessVideo && !accessVideo) return false;
        if (min.accessProposals && !accessProposals) return false;
        if (min.accessQuestions && !accessQuestions) return false;
        if (min.accessWiki && !accessWiki) return false;
        if (min.leftMenuLink && !leftMenuLink) return false;
        if (min.fastLink && !fastLink) return false;
        if (min.accessStatuses && !accessStatuses) return false;
        if (min.accessNotes && !accessNotes) return false;
        if (min.accessWall && !accessWall) return false;
        if (min.accessAds && !accessAds) return false;
        if (min.accessDocuments && !accessDocuments) return false;
        if (min.accessGroups && !accessGroups) return false;

        return true;
    }
}
}
