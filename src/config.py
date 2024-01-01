import os
import yaml
from dotenv import load_dotenv

load_dotenv()

SYSTEM_PARAMS = {
    "USER_PROMPT": "# These commands will be executed upon closing the file. Edit accordingly."
}


class Config:
    def __init__(self, config_filepath=None, enable_env=True):
        if config_filepath is None:
            USER_DATA_DIR = os.path.join(os.getenv("HOME"), ".shelly")
            with open(os.path.join(USER_DATA_DIR, "config.yml"), "r") as f:
                self.config = yaml.safe_load(f)
        else:
            with open(config_filepath, "r") as config_file:
                self.config = yaml.safe_load(config_file)
        self.enable_env = enable_env

    def get(self, param_name):
        if self.enable_env:
            value = os.getenv(param_name)
            if value is not None:
                return value
        if param_name in SYSTEM_PARAMS:
            return SYSTEM_PARAMS[param_name]
        return self.config[param_name]
