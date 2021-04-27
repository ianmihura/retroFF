import sys,os
import json

import i18n

def parse_settings(settings_url):
    try:
        with open(settings_url) as f:
            settings = json.load(f)

            if (not settings):
                raise Exception(i18n.ERROR_NO_SETTINGS) 
            
            return settings
    except:
        return i18n.ERROR_OPEN_SETTINGS

def save_settings(settings_url, settings):
    try:
        f = open(settings_url, "w")
        s_settings = json.dumps(settings)
        f.write(s_settings)
        return False
    except:
        return i18n.ERROR_SAVE_SETTINGS