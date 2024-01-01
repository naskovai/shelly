import requests
from src.errors import auth_error_message

_SYSTEM_PROMPT = (
    "You write unix commands. Output only commands. Just commands and nothing else."
)


class LLMService:
    def __init__(self, config):
        self.config = config
        self.url = config.get("OPENAI_COMPLETIONS_ENDPOINT_URL")
        self.headers = {
            "Authorization": f"Bearer {config.get('OPENAI_API_KEY')}",
            "Content-Type": "application/json",
        }

    def request_completion(self, prompt):
        request_data = {
            "model": self.config.get("OPENAI_MODEL_NAME"),
            "messages": [
                {
                    "role": "system",
                    "content": _SYSTEM_PROMPT,
                },
                {"role": "user", "content": prompt},
            ],
            "temperature": 0.01,
        }
        response = requests.post(self.url, json=request_data, headers=self.headers)
        self._handle_errors(response)
        return response.json()["choices"][0]["message"]["content"]

    def _handle_errors(self, response):
        if response.status_code == 401:
            message = response.json()['error']['message']
            raise Exception(auth_error_message(message))
