/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 10.04.12
 * Time: 0:45
 * To change this template use File | Settings | File Templates.
 */
package park
{
import basemvc.controller.CompositeController;

import config.Constants;

public class BaseSpaceObjectController extends CompositeController
{

    protected var _model:BaseSpaceObjectModel;
    protected var _view:BaseSpaceObjectView;

    public function BaseSpaceObjectController(objectId:int, classId:String)
    {
        _model = new BaseSpaceObjectModel(objectId, classId, Constants.CFG[classId]);
        _view = new BaseSpaceObjectView(_model);
    }

    public function getView():BaseSpaceObjectView
    {
        return _view;
    }

    public function getModel():BaseSpaceObjectModel
    {
        return _model;
    }
}
}
