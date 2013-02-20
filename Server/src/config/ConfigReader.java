package config;

import org.yaml.snakeyaml.Yaml;
import utils.CoreUtil;

import java.util.Map;

/**
 * Author: JuzTosS
 * Date: 15.11.12
 */
public class ConfigReader
{
    private static Map<String, Object> _config;

    public static Map<String, Object> cfg()
    {
        if (_config != null)
            return _config;

        Yaml yaml = new Yaml();
        String configString = CoreUtil.getLocalResource(Constants.LOCATION_CONFIG_NAME);
        Map<String, Object> configObj = (Map<String, Object>) yaml.load(configString);
        _config = configObj;
        return configObj;
    }
}
