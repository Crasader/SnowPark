/**
 * Author: JuzTosS
 * Date: 11.06.12
 */
package models
{

import flash.events.EventDispatcher;

public class UserModel extends EventDispatcher implements IBindableModel
{
    private static var _instanse:UserModel;

    public var _user_id:String;

    public function UserModel()
    {

    }
}
}
