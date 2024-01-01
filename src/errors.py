def auth_error_message(error):
    return f"""
{str(error)}

Your OPENAI_API_KEY is not working!
Please set it in 'shelly --config'.
"""
