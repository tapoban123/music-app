import os
import uuid
import bcrypt
import jwt
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session, joinedload
from dotenv import load_dotenv

from middleware.auth_middleware import auth_middleware
from models.user import User
from pydantic_schemas.user_create import UserCreate
from database import get_db
from pydantic_schemas.user_login import UserLogin

router = APIRouter()
load_dotenv()
JWT_KEY = os.getenv("JWT_PAYLOAD_KEY")


@router.post("/signup", status_code=201)
def sign_up_user(user: UserCreate, db: Session = Depends(get_db)):
    # extract the data that is coming from the request
    # check if the user already in DB
    user_db = db.query(User).filter(User.email == user.email).first()

    if user_db:
        raise HTTPException(
            status_code=400,
            detail="User with the same email already exists!",
        )

    hashed_password = bcrypt.hashpw((user.password).encode(), salt=bcrypt.gensalt())
    user_db = User(
        id=str(uuid.uuid4()),
        email=user.email,
        name=user.name,
        password=hashed_password,
    )
    # Add new user to database
    db.add(user_db)
    db.commit()
    db.refresh(user_db)

    return user_db


@router.post("/login")
def login_user(user: UserLogin, db: Session = Depends(get_db)):
    # checks if an user with a same email already or not
    user_db = db.query(User).filter(User.email == user.email).first()

    if not user_db:
        raise HTTPException(
            status_code=400,
            detail="User with this email does not exist!",
        )

    # password matching or not
    is_match = bcrypt.checkpw(
        password=user.password.encode(),
        hashed_password=user_db.password,
    )

    if not is_match:
        raise HTTPException(
            status_code=400,
            detail="Incorrect Password!",
        )

    token = jwt.encode({"id": user_db.id}, JWT_KEY)

    return {"token": token, "user": user_db}


@router.get('/')
def current_user_data(db: Session = Depends(get_db), user_dict=Depends(auth_middleware)):
    user = db.query(User).filter(User.id == user_dict['uid']).options(
        joinedload(User.favourites)
    ).first()

    if not user:
        raise HTTPException(404, "User not found!")

    return user
