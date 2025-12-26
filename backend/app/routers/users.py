from fastapi import APIRouter, HTTPException, Query, Depends, Request
from typing import List, Optional
from bson import ObjectId
from app.models import UserModel, PyObjectId

router = APIRouter()

@router.get("/", response_model=List[UserModel], summary="List users", description="List users with optional filters.")
async def list_users(request: Request, email: Optional[str] = Query(None), name: Optional[str] = Query(None)):
    query = {}
    if email:
        query["email"] = email
    if name:
        query["name"] = name
    db = request.app.db
    users = await db.users.find(query).to_list(100)
    return users

@router.get("/{user_id}", response_model=UserModel, summary="Get user by ID")
async def get_user(request: Request, user_id: str):
    db = request.app.db
    user = await db.users.find_one({"_id": ObjectId(user_id)})
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@router.post("/", response_model=dict, summary="Create user", description="Add a new user.")
async def create_user(request: Request, user: UserModel):
    db = request.app.db
    user_dict = user.dict(by_alias=True, exclude_unset=True)
    result = await db.users.insert_one(user_dict)
    return {"_id": str(result.inserted_id)}

@router.put("/{user_id}", response_model=dict, summary="Update user", description="Update a user by ID.")
async def update_user(request: Request, user_id: str, user: UserModel):
    db = request.app.db
    user_dict = user.dict(by_alias=True, exclude_unset=True)
    result = await db.users.update_one({"_id": ObjectId(user_id)}, {"$set": user_dict})
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="User not found")
    return {"updated": True}

@router.delete("/{user_id}", response_model=dict, summary="Delete user", description="Delete a user by ID.")
async def delete_user(request: Request, user_id: str):
    db = request.app.db
    result = await db.users.delete_one({"_id": ObjectId(user_id)})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="User not found")
    return {"deleted": True}
