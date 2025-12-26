from pydantic import BaseModel, Field, EmailStr
from typing import Optional, List, Dict, Any
from bson import ObjectId
from pydantic import GetCoreSchemaHandler, GetJsonSchemaHandler
from pydantic_core import core_schema

class PyObjectId(ObjectId):
    @classmethod
    def __get_pydantic_core_schema__(cls, source, handler: GetCoreSchemaHandler):
        return core_schema.json_or_python_schema(
            python_schema=core_schema.no_info_plain_validator_function(cls.validate),
            json_schema=core_schema.str_schema(),
            serialization=core_schema.plain_serializer_function_ser_schema(str)
        )

    @classmethod
    def __get_pydantic_json_schema__(cls, core_schema, handler: GetJsonSchemaHandler):
        return {'type': 'string', 'examples': ['507f1f77bcf86cd799439011']}

    @classmethod
    def validate(cls, v):
        if isinstance(v, ObjectId):
            return v
        if not ObjectId.is_valid(v):
            raise ValueError("Invalid ObjectId")
        return ObjectId(v)

class MovieModel(BaseModel):
    id: Optional[PyObjectId] = Field(default=None, alias="_id")
    title: str
    year: Optional[int] = None
    runtime: Optional[int] = None
    plot: Optional[str] = None
    genres: Optional[List[str]] = None
    cast: Optional[List[str]] = None
    directors: Optional[List[str]] = None
    countries: Optional[List[str]] = None
    poster: Optional[str] = None
    imdb: Optional[Dict[str, Any]] = None
    tomatoes: Optional[Dict[str, Any]] = None
    class Config:
        validate_by_name = True
        arbitrary_types_allowed = True
        json_encoders = {ObjectId: str}

class CommentModel(BaseModel):
    id: Optional[PyObjectId] = Field(default=None, alias="_id")
    movie_id: PyObjectId
    text: str
    date: Optional[str] = None
    name: Optional[str] = None
    email: Optional[EmailStr] = None
    class Config:
        validate_by_name = True
        arbitrary_types_allowed = True
        json_encoders = {ObjectId: str}

class UserModel(BaseModel):
    id: Optional[PyObjectId] = Field(default=None, alias="_id")
    name: Optional[str] = None
    email: EmailStr
    password: Optional[str] = None
    class Config:
        validate_by_name = True
        arbitrary_types_allowed = True
        json_encoders = {ObjectId: str}

class TheaterModel(BaseModel):
    id: Optional[PyObjectId] = Field(default=None, alias="_id")
    theaterId: int
    location: Dict[str, Any]
    class Config:
        validate_by_name = True
        arbitrary_types_allowed = True
        json_encoders = {ObjectId: str}

class EmbeddedMovieModel(BaseModel):
    id: Optional[PyObjectId] = Field(default=None, alias="_id")
    # Add fields as per sample document
    class Config:
        validate_by_name = True
        arbitrary_types_allowed = True
        json_encoders = {ObjectId: str}

class SessionModel(BaseModel):
    id: Optional[PyObjectId] = Field(default=None, alias="_id")
    user_id: PyObjectId
    jwt: str
    class Config:
        validate_by_name = True
        arbitrary_types_allowed = True
        json_encoders = {ObjectId: str}
