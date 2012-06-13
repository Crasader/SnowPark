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

import models.CameraModel;

import mx.binding.utils.BindingUtils;

public class CameraView extends IsoView
{
    public function CameraView()
    {
        super();
        this.setSize(480, 320);
        BindingUtils.bindProperty(mainContainer, "x", CameraModel.instanse, "_x");
        BindingUtils.bindProperty(mainContainer, "y", CameraModel.instanse, "_y");
        BindingUtils.bindSetter(zoom, CameraModel.instanse, "_zoom");

    }
}
}
