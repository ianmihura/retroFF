import sys,os
import argparse

import gui
import xfile

def main():
    # Get parsed arguements
    parser = argparse.ArgumentParser()
    parser.add_argument('-home', type=str)
    parser.add_argument('-settings', type=str)

    args = parser.parse_args()
    settings_url = args.settings
    settings = xfile.parse_settings(settings_url)

    gui.init_tk(settings_url, settings)

if __name__ == '__main__':
    main()
