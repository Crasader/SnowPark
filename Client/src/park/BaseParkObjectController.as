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

public class BaseParkObjectController extends CompositeController
{
    public function BaseParkObjectController()
    {
    }

    public function getView():BaseParkObjectView
    {
        return null;
    }

    public function getModel():BaseParkObjectModel
    {
        return null;
    }
}
}
