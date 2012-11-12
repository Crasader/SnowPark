package utils;

import java.math.BigInteger;
import java.nio.charset.Charset;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Random;

/**
 * Author: JuzTosS
 * Date: 02.11.12
 */
public class CryptUtil
{
    public static String getSalt(int saltLength) throws Exception
    {
        if(saltLength <= 0) throw new Exception("wrong saltLength, must be > 0");

        Random r = new SecureRandom();
        byte[] salt = new byte[saltLength];

        r.nextBytes(salt);
        return new BigInteger(1, salt).toString(16);

    }

    public static byte[] createMD5(byte[] raw)
    {
        byte[] output = null;
        try
        {
            MessageDigest md;
            md = MessageDigest.getInstance("MD5");
            md.update(raw, 0, raw.length);
            output = md.digest();
        }
        catch (NoSuchAlgorithmException e)
        {
            e.printStackTrace();
        }
        return output;
    }

    public static String hashPass(String pass, String salt)
    {
        Charset charset = Charset.forName("UTF-8");

        byte[] MD5Pass = createMD5(pass.getBytes(charset));
        String MD5PassString = new BigInteger(1, MD5Pass).toString(16);

        String saltedPass = MD5PassString + salt;

        return new BigInteger(1, createMD5(saltedPass.getBytes(charset))).toString(16);
    }
}
