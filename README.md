# godot-vibe-plugin

A Vibe Coding Assistent for Godot Engine

## Instructions

### FastAPI

Before getting started, you must create a [Github Personal Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) to access the AI model from [Github Models](https://github.com/marketplace?type=models).

Once you created your personal token, create a .env file with the following:

```text
GITHUB_TOKEN="YOUR_TOKEN_HERE"
```

Then, run the FastAPI server using the fastapi command in the terminal (assuming you're inside the backend folder):

```bash
fastapi dev main.py
```
