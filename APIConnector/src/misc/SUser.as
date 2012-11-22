package misc
{
public class SUser
{

    public static const SEX_UNDEFINED:int = -1;
    public static const SEX_NO_SEX:int = 0;
    public static const SEX_FEMALE:int = 1;
    public static const SEX_MALE:int = 2;

    public var id:String;
    public var first_name:String;
    public var last_name:String;
    public var nickname:String;
    public var sex:Number = SEX_UNDEFINED;
    public var birthdate:Date;
    public var avatar_pic:String;
    public var photo_medium:String;
    public var photo_big:String;
    public var city:String;
    public var country:String;

    public function SUser()
    {
    }
}
}