from fastapi import APIRouter, HTTPException, Query, Depends, Request
from typing import List, Optional
from bson import ObjectId
from app.models import TheaterModel, PyObjectId

router = APIRouter()

@router.get("/", response_model=List[TheaterModel], summary="List theaters", description="List theaters with optional filters.")
async def list_theaters(request: Request, theaterId: Optional[int] = Query(None)):
    query = {}
    if theaterId:
        query["theaterId"] = theaterId
    db = request.app.db
    theaters = await db.theaters.find(query).to_list(100)
    return theaters

@router.get("/{theater_id}", response_model=TheaterModel, summary="Get theater by ID")
async def get_theater(request: Request, theater_id: str):
    db = request.app.db
    theater = await db.theaters.find_one({"_id": ObjectId(theater_id)})
    if not theater:
        raise HTTPException(status_code=404, detail="Theater not found")
    return theater

@router.post("/", response_model=dict, summary="Create theater", description="Add a new theater.")
async def create_theater(request: Request, theater: TheaterModel):
    db = request.app.db
    theater_dict = theater.dict(by_alias=True, exclude_unset=True)
    result = await db.theaters.insert_one(theater_dict)
    return {"_id": str(result.inserted_id)}

@router.put("/{theater_id}", response_model=dict, summary="Update theater", description="Update a theater by ID.")
async def update_theater(request: Request, theater_id: str, theater: TheaterModel):
    db = request.app.db
    theater_dict = theater.dict(by_alias=True, exclude_unset=True)
    result = await db.theaters.update_one({"_id": ObjectId(theater_id)}, {"$set": theater_dict})
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="Theater not found")
    return {"updated": True}

@router.delete("/{theater_id}", response_model=dict, summary="Delete theater", description="Delete a theater by ID.")
async def delete_theater(request: Request, theater_id: str):
    db = request.app.db
    result = await db.theaters.delete_one({"_id": ObjectId(theater_id)})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Theater not found")
    return {"deleted": True}
