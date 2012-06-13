/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 10.04.12
 * Time: 0:45
 * To change this template use File | Settings | File Templates.
 */
package park.static
{
import park.BaseParkObjectController;
import park.BaseParkObjectModel;
import park.BaseParkObjectView;

public class SimpleBlockController extends BaseParkObjectController
{
    protected var _block_model:SimpleBlockModel;
    protected var _block_view:SimpleBlockView;

    public function SimpleBlockController()
    {

        _block_model = new SimpleBlockModel();
        _block_view = new SimpleBlockView(_block_model);

    }


    override public function getModel():BaseParkObjectModel
    {
        return _block_model;
    }

    override public function getView():BaseParkObjectView
    {
        return _block_view;
    }
}
}
