/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 10.04.12
 * Time: 0:45
 * To change this template use File | Settings | File Templates.
 */
package park.static
{
import park.BaseSpaceObjectController;
import park.BaseSpaceObjectModel;
import park.BaseSpaceObjectView;

public class SpaceObjController extends BaseSpaceObjectController
{
    protected var _block_model:SpaceObjModel;
    protected var _block_view:SpaceObjView;

    public function SpaceObjController()
    {

        _block_model = new SpaceObjModel();
        _block_view = new SpaceObjView(_block_model);

    }


    override public function getModel():BaseSpaceObjectModel
    {
        return _block_model;
    }

    override public function getView():BaseSpaceObjectView
    {
        return _block_view;
    }
}
}
