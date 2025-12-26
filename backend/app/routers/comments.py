from fastapi import APIRouter, HTTPException, Query, Depends, Request
from typing import List, Optional
from bson import ObjectId
from app.models import CommentModel, PyObjectId

router = APIRouter()

@router.get("/", response_model=List[CommentModel], summary="List comments", description="List comments with optional filters.")
async def list_comments(request: Request, movie_id: Optional[str] = Query(None), email: Optional[str] = Query(None)):
    query = {}
    if movie_id:
        query["movie_id"] = ObjectId(movie_id)
    if email:
        query["email"] = email
    db = request.app.db
    comments = await db.comments.find(query).to_list(100)
    return comments

@router.get("/{comment_id}", response_model=CommentModel, summary="Get comment by ID")
async def get_comment(request: Request, comment_id: str):
    db = request.app.db
    comment = await db.comments.find_one({"_id": ObjectId(comment_id)})
    if not comment:
        raise HTTPException(status_code=404, detail="Comment not found")
    return comment

@router.post("/", response_model=dict, summary="Create comment", description="Add a new comment.")
async def create_comment(request: Request, comment: CommentModel):
    db = request.app.db
    comment_dict = comment.dict(by_alias=True, exclude_unset=True)
    result = await db.comments.insert_one(comment_dict)
    return {"_id": str(result.inserted_id)}

@router.put("/{comment_id}", response_model=dict, summary="Update comment", description="Update a comment by ID.")
async def update_comment(request: Request, comment_id: str, comment: CommentModel):
    db = request.app.db
    comment_dict = comment.dict(by_alias=True, exclude_unset=True)
    result = await db.comments.update_one({"_id": ObjectId(comment_id)}, {"$set": comment_dict})
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="Comment not found")
    return {"updated": True}

@router.delete("/{comment_id}", response_model=dict, summary="Delete comment", description="Delete a comment by ID.")
async def delete_comment(request: Request, comment_id: str):
    db = request.app.db
    result = await db.comments.delete_one({"_id": ObjectId(comment_id)})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Comment not found")
    return {"deleted": True}
