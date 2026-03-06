import os
from dotenv import load_dotenv
from openai import OpenAI

load_dotenv()

token = os.environ["GITHUB_TOKEN"]
endpoint = "https://models.github.ai/inference"
model_name = "openai/gpt-4o-mini"

client = OpenAI(
    base_url=endpoint,
    api_key=token,
)

response_style = """Return your answer in raw Json format instructions for Godot Engine editor menu (used as a EditorScript).

The values of the parameters can be a string, int, float, boolean, list or dictionary, depending on the context of the instruction.

The JSON should have the following structure: 
{
    "instruction": {
        "parameter1": "value 1",
        "parameter2": "value 2",
        ...
    }
}
Replace instruction with the name of the instruction you want to execute and add the necessary parameters for that instruction.

The possible instructions are:
- "print": Print a message to the console. The parameter is "message" (string).
- "create_node": Create a new node in the scene tree. The parameters are "node_type" (string) and "node_name" (string).
- "remove_node": Remove a node in the scene tree. The parameters are "node_name" (string).
"""

json_response_structure = {
    "answer": "your answer here"
}

def test_chat(message: str = "What is Godot Engine?") -> str:
    response = client.chat.completions.create(
        messages=[
        {
            "role": "system",
            "content": response_style,
        },
        {
            "role": "user",
            "content": message,
        }
    ],
    temperature=1.0,
    top_p=1.0,
    max_tokens=1000,
    model=model_name
)
    
    return response.choices[0].message.content