/**
 * Author: JuzTosS
 * Date: 06.11.12
 */
package net.loaders
{
import flash.events.EventDispatcher;

public class MovieLoader extends EventDispatcher
{
    public static const MOVIE_LOADED:String = "snow_movie_loaded";
    public static const ERROR_LOAD_MOVIE:String = "snow_error_load_movie";

    public function MovieLoader()
    {
    }
}
}
