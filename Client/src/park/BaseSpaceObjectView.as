/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 14.04.12
 * Time: 21:14
 * To change this template use File | Settings | File Templates.
 */
package park
{
import as3isolib.display.IsoSprite;

import com.junkbyte.console.Cc;

import config.Constants;

import flash.events.Event;

import mx.binding.utils.BindingUtils;

import net.loaders.MovieLoader;

import views.FieldView;

public class BaseSpaceObjectView extends IsoSprite
{
    protected var _model:IBaseSpaceObjectModel;

    private var _visual:MovieLoader;

    public function BaseSpaceObjectView(model:IBaseSpaceObjectModel)
    {
        _model = model;
        BindingUtils.bindSetter(updateXPos, model, "_x");
        BindingUtils.bindSetter(updateYPos, model, "_y");
        BindingUtils.bindSetter(updateZPos, model, "_z");

        addEventListener(Event.ADDED_TO_STAGE, onStage);

        _visual = new MovieLoader(Constants.GRAPHICS_PATH + _model.cfgView["field"]);
        _visual.addEventListener(MovieLoader.MOVIE_LOADED, onMovieLoaded);
        _visual.addEventListener(MovieLoader.ERROR_LOAD_MOVIE, onErrorLoadMovie);
        sprites = [_visual];
    }

    private function onErrorLoadMovie(event:Event):void
    {
        Cc.error("Error load movie for object " + _model.classId + ", path = " + "\"" + _model.cfgView["field"] + "\"");
    }

    private function onMovieLoaded(event:Event):void
    {

    }

    private function onStage(event:Event):void
    {
        _visual.startLoad();
    }

    private function updateYPos(value:int):void
    {
        this.y = FieldView.CELL_SIZE * value;
    }

    private function updateZPos(value:Number):void
    {
        this.z = FieldView.CELL_SIZE * value;
    }

    private function updateXPos(value:int):void
    {
        this.x = FieldView.CELL_SIZE * value;
    }
}
}
