/**
 * Author: JuzTosS
 * Date: 09.11.12
 */
package objects
{
import models.IBindableModel;
import models.IFieldModel;

import objects.components.IViewComponent;

public interface IObjectModel extends IBindableModel
{
    function get x():int;

    function get y():int;

    function get z():int;

    function get _space():int;

    function get classId():String;

    function get cfg():Object;

    function get cfgView():Object;

    function get cfgShop():Object;

    function get cfgBehavior():Object;

    function get cfgDescriptions():Object;

    function get fieldModel():IFieldModel;

    function setPos(x:int, y:int):void;

    function get components():Vector.<IViewComponent>;
}
}
