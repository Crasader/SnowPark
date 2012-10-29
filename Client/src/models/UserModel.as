/**
 * Author: JuzTosS
 * Date: 11.06.12
 */
package models
{
import crypt.Crypter;

public class UserModel
{
    private static var _instanse:UserModel;

    public var _login:String;
    public var _password:String;

    [Bindable]
    public var _auth_passed:Boolean = false;

    public function UserModel()
    {

    }

    public static function get instanse():UserModel
    {
        if(_instanse == null)
        {
            _instanse = new UserModel();
        }

        return _instanse;
    }

    public function get pass_hash():String
    {
        return Crypter.encrypt(_password);
    }

    public function auth_passed():void
    {
        _auth_passed = true;
    }
}
}
