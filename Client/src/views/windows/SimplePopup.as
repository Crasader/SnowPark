/**
 * Author: JuzTosS
 * Date: 04.12.12
 */
package views.windows
{
import flash.events.Event;
import flash.text.TextField;

public class SimplePopup extends BaseWindow
{
    private var _header:String;
    private var _content:String;

    public function SimplePopup(header:String, content:String)
    {
        _header = header;
        _content = content;
        loadVisual();
    }

    override protected function onLoaded(event:Event):void
    {
        super.onLoaded(event);
        createCloseButton();
        headerTF.text = _header;
        contentTF.text = _content;

        addChild(visual);
    }

    override protected function resourceName():String
    {
        return "gui/Popup.swf"
    }

    private function get headerTF():TextField
    {
        return getChildByNameAs("header", TextField) as TextField;
    }

    private function get contentTF():TextField
    {
        return getChildByNameAs("content", TextField) as TextField;
    }
}
}
