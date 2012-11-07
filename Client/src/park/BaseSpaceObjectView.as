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

import flash.events.Event;

import mx.binding.utils.BindingUtils;

import net.loaders.MovieLoader;

import views.FieldView;

public class BaseSpaceObjectView extends IsoSprite
{
    protected var _baseModel:BaseSpaceObjectModel;

    private var _movieLoader:MovieLoader = new MovieLoader();

    public function BaseSpaceObjectView(model:BaseSpaceObjectModel)
    {
        _baseModel = model;
        BindingUtils.bindSetter(updateXPos, model, "_x");
        BindingUtils.bindSetter(updateYPos, model, "_y");

        addEventListener(Event.ADDED_TO_STAGE, onStage);
        _movieLoader.addEventListener(MovieLoader.MOVIE_LOADED, onMovieLoaded);
        _movieLoader.addEventListener(MovieLoader.ERROR_LOAD_MOVIE, onErrorLoadMovie);
    }

    private function onErrorLoadMovie(event:MovieLoader):void
    {

    }

    private function onMovieLoaded(event:MovieLoader):void
    {

    }

    private function onStage(event:Event):void
    {
//        _movieLoader.load()
    }

    private function updateYPos(value:int):void
    {
        this.y = FieldView.CELL_SIZE * value;
    }

    private function updateXPos(value:int):void
    {
        this.x = FieldView.CELL_SIZE * value;
    }
}
}
