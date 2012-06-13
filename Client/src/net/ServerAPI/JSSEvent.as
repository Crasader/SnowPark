package net.ServerAPI
{
import flash.events.Event;

public class JSSEvent extends Event
{
    public static const CONNECT_TO_SERVER_SOCKET:String = "connection";

    // Errors
    public static const CONNECTION_LOST:String = "connectionLost";
    public static const SOCKET_ERROR:String = "socketError";
    public static const SECURITY_ERROR:String = "securityError";

    // Requests responces
    public static const UNHANDLED_SERVER_REQUEST:String = "serverRequest";
    public static const LOGIN_SUCCESS:String = "loginSuccess";
    public static const LOGIN_ERROR:String = "loginError";
    public static const UPDATE_USER_INFO_ERROR:String = "updateUserInfoError";
    public static const UPDATE_USER_INFO_SUCCESS:String = "updateUserInfoSuccess";
    public static const PUBLIC_MESSAGE:String = "publicMessage";
    public static const RECEIVE_DATA:String = "receiveData";
    public static const PING_SUCCESS:String = "pingSuccess";
    public static const ALERT_OF_DISCONNECTION:String = "disconnect";
    public static const LOG:String = "log";

    private var _data:Object;

    public function JSSEvent(type:String, data:Object = null)
    {
        super(type, bubbles, cancelable);
        _data = data;

    }

    public function get data():Object
    {
        return _data;

    }

}
}