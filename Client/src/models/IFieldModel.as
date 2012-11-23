/**
 * Author: JuzTosS
 * Date: 15.11.12
 */
package models
{
import objects.ObjectModel;

public interface IFieldModel extends IBindableModel
{
    function get allObjects():Vector.<ObjectModel>;

    function getHeight(x:int, y:int):int;

    function isPlaceFree(x:int, y:int, width:int = 1, length:int = 1):Boolean

    function get activeTool():String;
}
}
