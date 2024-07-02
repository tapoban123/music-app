from fastapi import FastAPI

from models.base import Base
from routes import auth
from database import engine


app = FastAPI()

app.include_router(auth.router, prefix="/auth")


# Telling the sqlalchemy to create tables of all the classes that extends Base
Base.metadata.create_all(engine)
