/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 10.04.12
 * Time: 0:45
 * To change this template use File | Settings | File Templates.
 */
package objects
{
import basemvc.controller.CompositeController;

import config.Constants;

import models.FieldModel;

public class ObjectController extends CompositeController
{

    protected var _model:ObjectModel;
    protected var _view:ObjectView;

    public function ObjectController(classId:String, fieldModel:FieldModel)
    {
        var config:Object = Constants.CFG[classId];
        if (!config) throw "Can't create object without config " + "( classId = " + classId + " )";

        _model = new ObjectModel(classId, config, fieldModel);
        _view = new ObjectView(_model);

    }

    public function getView():ObjectView
    {
        return _view;
    }

    public function getModel():ObjectModel
    {
        return _model;
    }
}
}
