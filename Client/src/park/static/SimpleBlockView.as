/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 14.04.12
 * Time: 21:18
 * To change this template use File | Settings | File Templates.
 */
package park.static
{
import flash.events.Event;

import mx.binding.utils.BindingUtils;

import park.BaseParkObjectView;

import views.FieldView;

public class SimpleBlockView extends BaseParkObjectView
{
    public function SimpleBlockView(m:SimpleBlockModel)
    {
        super(m);
        width = FieldView.CELL_SIZE;
        length = FieldView.CELL_SIZE;
        height = m._height;

        BindingUtils.bindSetter(setHeight, m, "_height");
    }

    private function setHeight(value:int):void
    {
        height = value;
        render();
    }
}
}
