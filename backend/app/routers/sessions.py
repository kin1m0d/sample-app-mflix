from fastapi import APIRouter, HTTPException, Query, Depends, Request
from typing import List, Optional
from bson import ObjectId
from app.models import SessionModel, PyObjectId

router = APIRouter()

@router.get("/", response_model=List[SessionModel], summary="List sessions", description="List sessions with optional filters.")
async def list_sessions(request: Request, user_id: Optional[str] = Query(None)):
    query = {}
    if user_id:
        query["user_id"] = ObjectId(user_id)
    db = request.app.db
    sessions = await db.sessions.find(query).to_list(100)
    return sessions

@router.get("/{session_id}", response_model=SessionModel, summary="Get session by ID")
async def get_session(request: Request, session_id: str):
    db = request.app.db
    session = await db.sessions.find_one({"_id": ObjectId(session_id)})
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
    return session

@router.post("/", response_model=dict, summary="Create session", description="Add a new session.")
async def create_session(request: Request, session: SessionModel):
    db = request.app.db
    session_dict = session.dict(by_alias=True, exclude_unset=True)
    result = await db.sessions.insert_one(session_dict)
    return {"_id": str(result.inserted_id)}

@router.put("/{session_id}", response_model=dict, summary="Update session", description="Update a session by ID.")
async def update_session(request: Request, session_id: str, session: SessionModel):
    db = request.app.db
    session_dict = session.dict(by_alias=True, exclude_unset=True)
    result = await db.sessions.update_one({"_id": ObjectId(session_id)}, {"$set": session_dict})
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="Session not found")
    return {"updated": True}

@router.delete("/{session_id}", response_model=dict, summary="Delete session", description="Delete a session by ID.")
async def delete_session(request: Request, session_id: str):
    db = request.app.db
    result = await db.sessions.delete_one({"_id": ObjectId(session_id)})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Session not found")
    return {"deleted": True}
