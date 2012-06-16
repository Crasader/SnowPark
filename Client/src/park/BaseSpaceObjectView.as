/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 14.04.12
 * Time: 21:14
 * To change this template use File | Settings | File Templates.
 */
package park
{
import as3isolib.display.primitive.IsoBox;

import mx.binding.utils.BindingUtils;

import views.FieldView;

public class BaseSpaceObjectView extends IsoBox
{
    protected var _base_model:BaseSpaceObjectModel;

    public function BaseSpaceObjectView(model:BaseSpaceObjectModel)
    {
        _base_model = model;
        BindingUtils.bindSetter(update_x_pos, model, "_x");
        BindingUtils.bindSetter(update_y_pos, model, "_y");
    }

    private function update_y_pos(value:int):void
    {
        this.y = FieldView.CELL_SIZE * value;
    }

    private function update_x_pos(value:int):void
    {
        this.x = FieldView.CELL_SIZE * value;
    }
}
}
