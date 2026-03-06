from fastapi import FastAPI
from pydantic import BaseModel
from test_openai import test_chat

app = FastAPI()

class Item(BaseModel):
    name: str
    price: float
    is_offer: bool | None = None

class Chat(BaseModel):
    message: str


@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.post("/chat")
async def read_chat(chat: Chat):
    return {"response": test_chat(chat.message)}

@app.get("/items/{item_id}")
def read_item(item_id: int, q: str | None = None):
    return {"item_id": item_id, "q": q}

@app.put("/items/{item_id}")
def update_item(item_id: int, item: Item):
    return {"item_name": item.name, "item_id": item_id}