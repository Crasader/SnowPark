/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 24.03.12
 * Time: 17:35
 * To change this template use File | Settings | File Templates.
 */
package views
{
import as3isolib.display.IsoView;

import config.Constants;

import models.IBindableModel;

import mx.binding.utils.BindingUtils;

public class CameraView extends IsoView
{
    public function CameraView(model:IBindableModel)
    {
        super();
        setSize(Constants.STAGE_WIDTH, Constants.STAGE_HEIGHT);
        mouseChildren = false;
        mouseEnabled = false;
        BindingUtils.bindProperty(mainContainer, "x", model, "_x");
        BindingUtils.bindProperty(mainContainer, "y", model, "_y");
        BindingUtils.bindSetter(zoom, model, "_zoom");

    }
}
}
