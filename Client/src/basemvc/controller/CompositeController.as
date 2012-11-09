/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 24.03.12
 * Time: 16:23
 * To change this template use File | Settings | File Templates.
 */
package basemvc.controller
{
import basemvc.compose.CompositeObject;

public class CompositeController extends CompositeObject
{
    private static var _root_controller:CompositeController;

    public function CompositeController()
    {
        if (!_root_controller) _root_controller = this;
    }

    public function get core():CompositeController
    {
        return _root_controller;
    }

}
}
