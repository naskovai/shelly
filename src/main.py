import os, sys
import json
from src.config import Config
from src.llm_service import LLMService


def make_output(generated_commands, config):
    return f"{config.get('USER_PROMPT')}{os.linesep}{generated_commands}"


def generate_response(user_prompt, config):
    llm = LLMService(config)
    response = {"input": user_prompt}

    try:
        generated_commands = llm.request_completion(user_prompt)
        response["output"] = make_output(generated_commands, config)
    except Exception as e:
        response["error"] = str(e)

    return response


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit(1)

    user_prompt = sys.argv[1]
    response = generate_response(user_prompt, config=Config())
    print(json.dumps(response))
