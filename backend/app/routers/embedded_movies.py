from fastapi import APIRouter, HTTPException, Query, Depends, Request
from typing import List, Optional
from bson import ObjectId
from app.models import EmbeddedMovieModel, PyObjectId

router = APIRouter()

@router.get("/", response_model=List[EmbeddedMovieModel], summary="List embedded movies", description="List embedded movies with optional filters.")
async def list_embedded_movies(request: Request):
    db = request.app.db
    embedded_movies = await db.embedded_movies.find().to_list(100)
    return embedded_movies

@router.get("/{embedded_movie_id}", response_model=EmbeddedMovieModel, summary="Get embedded movie by ID")
async def get_embedded_movie(request: Request, embedded_movie_id: str):
    db = request.app.db
    embedded_movie = await db.embedded_movies.find_one({"_id": ObjectId(embedded_movie_id)})
    if not embedded_movie:
        raise HTTPException(status_code=404, detail="Embedded movie not found")
    return embedded_movie

@router.post("/", response_model=dict, summary="Create embedded movie", description="Add a new embedded movie.")
async def create_embedded_movie(request: Request, embedded_movie: EmbeddedMovieModel):
    db = request.app.db
    embedded_movie_dict = embedded_movie.dict(by_alias=True, exclude_unset=True)
    result = await db.embedded_movies.insert_one(embedded_movie_dict)
    return {"_id": str(result.inserted_id)}

@router.put("/{embedded_movie_id}", response_model=dict, summary="Update embedded movie", description="Update an embedded movie by ID.")
async def update_embedded_movie(request: Request, embedded_movie_id: str, embedded_movie: EmbeddedMovieModel):
    db = request.app.db
    embedded_movie_dict = embedded_movie.dict(by_alias=True, exclude_unset=True)
    result = await db.embedded_movies.update_one({"_id": ObjectId(embedded_movie_id)}, {"$set": embedded_movie_dict})
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="Embedded movie not found")
    return {"updated": True}

@router.delete("/{embedded_movie_id}", response_model=dict, summary="Delete embedded movie", description="Delete an embedded movie by ID.")
async def delete_embedded_movie(request: Request, embedded_movie_id: str):
    db = request.app.db
    result = await db.embedded_movies.delete_one({"_id": ObjectId(embedded_movie_id)})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Embedded movie not found")
    return {"deleted": True}
