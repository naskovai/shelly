import os, sys

_PARENT_DIR_PATH = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, _PARENT_DIR_PATH)

import unittest
from src.main import generate_response, make_output
from src.config import Config


class TestMainFunctions(unittest.TestCase):
    def test_generate_response(self):
        config = Config(os.path.join(_PARENT_DIR_PATH, "default_config.yml"))

        input = "git history"
        expected_output = {
            "input": input,
            "output": make_output("git log", config),
        }

        response = generate_response(input, config)
        self.assertEqual(response, expected_output)

    def test_wrong_openai_api_key(self):
        config = Config(os.path.join(_PARENT_DIR_PATH, "default_config.yml"), enable_env=False)

        input = "git history"
        response = generate_response(input, config)

        self.assertTrue('error' in response)


if __name__ == "__main__":
    unittest.main()
