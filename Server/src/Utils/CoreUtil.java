package utils;

import java.io.*;

/**
 * Author: JuzTosS
 * Date: 10.11.12
 */
public class CoreUtil
{
    public static String getLocalResource(String theName) {
        try {
            InputStream input;
            input = new DataInputStream(new FileInputStream(theName));
            if (input == null) {
                throw new RuntimeException("Can not find " + theName);
            }
            BufferedInputStream is = new BufferedInputStream(input);
            StringBuilder buf = new StringBuilder(3000);
            int i;
            try {
                while ((i = is.read()) != -1) {
                    buf.append((char) i);
                }
            } finally {
                is.close();
            }
            String resource = buf.toString();
            // convert EOLs
            String[] lines = resource.split("\\r?\\n");
            StringBuilder buffer = new StringBuilder();
            for (int j = 0; j < lines.length; j++) {
                buffer.append(lines[j]);
                buffer.append("\n");
            }
            return buffer.toString();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
