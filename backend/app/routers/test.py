from fastapi import APIRouter

router = APIRouter()

@router.get("/test", summary="Test endpoint")
async def test_endpoint():
    return {"message": "hello world"}
