/**
 * Author: JuzTosS
 * Date: 15.11.12
 */
package models
{
import objects.BaseSpaceObjectModel;

public interface IFieldModel extends IBindableModel
{
    function get allObjects():Vector.<BaseSpaceObjectModel>;

    function getHeight(x:int, y:int):int;

}
}
