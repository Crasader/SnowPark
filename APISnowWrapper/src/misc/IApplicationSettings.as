/**
 * Author: JuzTosS
 * Date: 07.06.12
 */
package misc
{
public interface IApplicationSettings
{
    function get friends_access():Boolean
    function get foto_access():Boolean
    function get audio_access():Boolean
    function get video_access():Boolean
    function get applications_access():Boolean
    function get questions_access():Boolean
    function get wiki_access():Boolean
    function get link_to_app():Boolean
    function get status_access():Boolean
    function get notes_access():Boolean
    function get wall_access():Boolean
    function get groups_access():Boolean

    function set friends_access(value:Boolean):void
    function set foto_access(value:Boolean):void
    function set audio_access(value:Boolean):void
    function set video_access(value:Boolean):void
    function set applications_access(value:Boolean):void
    function set questions_access(value:Boolean):void
    function set wiki_access(value:Boolean):void
    function set link_to_app(value:Boolean):void
    function set status_access(value:Boolean):void
    function set notes_access(value:Boolean):void
    function set wall_access(value:Boolean):void
    function set groups_access(value:Boolean):void

    function get serialized():Object
    function set serialized(serialized_obj:Object):void
}
}