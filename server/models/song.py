from sqlalchemy import Column, TEXT, VARCHAR

from models.base import Base


class Song(Base):
    __tablename__ = "songs"

    id = Column(TEXT, primary_key=True)
    song_url = Column(TEXT)
    thumbnail_url = Column(TEXT)
    artist = Column(TEXT)
    song_name = Column(VARCHAR(100))
    hex_code = Column(VARCHAR(6))

