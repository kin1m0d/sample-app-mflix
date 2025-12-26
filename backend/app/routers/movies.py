from fastapi import APIRouter, HTTPException, Query, Depends
from typing import List, Optional
from bson import ObjectId
from app.models import MovieModel, PyObjectId
from motor.motor_asyncio import AsyncIOMotorDatabase
from fastapi import Request

router = APIRouter()

async def get_db(request: Request) -> AsyncIOMotorDatabase:
    return request.app.state.db if hasattr(request.app.state, "db") else request.app.db

@router.get("/", response_model=List[MovieModel], summary="List movies", description="List movies with optional filters.")
async def list_movies(request: Request, title: Optional[str] = Query(None), year: Optional[int] = Query(None)):
    query = {}
    if title:
        query["title"] = title
    if year:
        query["year"] = year
    db = request.app.db
    movies = await db.movies.find(query).to_list(100)
    return movies

@router.get("/{movie_id}", response_model=MovieModel, summary="Get movie by ID")
async def get_movie(request: Request, movie_id: str):
    db = request.app.db
    movie = await db.movies.find_one({"_id": ObjectId(movie_id)})
    if not movie:
        raise HTTPException(status_code=404, detail="Movie not found")
    return movie

@router.post("/", response_model=dict, summary="Create movie", description="Add a new movie.")
async def create_movie(request: Request, movie: MovieModel):
    db = request.app.db
    movie_dict = movie.dict(by_alias=True, exclude_unset=True)
    result = await db.movies.insert_one(movie_dict)
    return {"_id": str(result.inserted_id)}

@router.put("/{movie_id}", response_model=dict, summary="Update movie", description="Update a movie by ID.")
async def update_movie(request: Request, movie_id: str, movie: MovieModel):
    db = request.app.db
    movie_dict = movie.dict(by_alias=True, exclude_unset=True)
    result = await db.movies.update_one({"_id": ObjectId(movie_id)}, {"$set": movie_dict})
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="Movie not found")
    return {"updated": True}

@router.delete("/{movie_id}", response_model=dict, summary="Delete movie", description="Delete a movie by ID.")
async def delete_movie(request: Request, movie_id: str):
    db = request.app.db
    result = await db.movies.delete_one({"_id": ObjectId(movie_id)})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Movie not found")
    return {"deleted": True}
