/**
 * Author: JuzTosS
 * Date: 09.11.12
 */
package park
{
public interface IBaseSpaceObjectModel
{
    function get _x():int;

    function get _y():int;

    function get _width():int;

    function get _length():int;

    function get _z():Number;

    function get _group():int;

    function get classId():String;

    function get _objectId():int;

    function get config():Object;

    function get cfgView():Object;

    function get cfgShop():Object;

    function get cfgBehavior():Object;

    function get cfgDescriptions():Object;

}
}
