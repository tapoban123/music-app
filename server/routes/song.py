import os
import cloudinary
import cloudinary.uploader
from dotenv import load_dotenv
from fastapi import APIRouter, UploadFile, File, Form, Depends
from sqlalchemy.orm import Session

from database import get_db
from middleware.auth_middleware import auth_middleware

router = APIRouter()
load_dotenv()

API_SECRET = os.getenv("CLOUDINARY_API_SECRET")

cloudinary.config(
    cloud_name="dxr5qyipc",
    api_key="998345117982937",
    api_secret=API_SECRET,
    secure=True
)


# The three dots in each of the parameters signify that they are required parameters
@router.post("/upload")
def upload_song(song: UploadFile = File(...),
                thumbnail: UploadFile = File(...),
                artist: str = Form(...),
                song_name: str = Form(...),
                hex_code: str = Form(...),
                db: Session = Depends(get_db),
                auth_dict=Depends(auth_middleware), ):
    pass
