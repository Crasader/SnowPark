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

import flash.profiler.profile;

public class BaseSpaceObjectController extends CompositeController
{
    public function BaseSpaceObjectController()
    {
    }

    public function getView():BaseSpaceObjectView
    {
        return null;
    }

    public function getModel():BaseSpaceObjectModel
    {
        return null;
    }
}
}
