import os
from dotenv import load_dotenv
load_dotenv()
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from motor.motor_asyncio import AsyncIOMotorClient
from app.routers import movies, comments, users, theaters, embedded_movies, sessions, test




app = FastAPI()

# CORS middleware
app.add_middleware(
	CORSMiddleware,
	allow_origins=["*"],  # or specify your web app's origin
	allow_credentials=True,
	allow_methods=["*"],
	allow_headers=["*"],
)

# MongoDB connection
MONGODB_URI = os.getenv("MONGODB_URI")
DB_NAME = os.getenv("MONGODB_DB", "sample_mflix")
client = AsyncIOMotorClient(MONGODB_URI)
db = client[DB_NAME]


# Attach db to app state for routers
app.db = db

# Fail fast if DB is unreachable
@app.on_event("startup")
async def check_db_connection():
	try:
		await db.command("ping")
	except Exception as e:
		import sys
		print(f"Failed to connect to MongoDB: {e}", file=sys.stderr)
		raise SystemExit(1)

# Routers
app.include_router(movies.router, prefix="/movies", tags=["movies"])
app.include_router(comments.router, prefix="/comments", tags=["comments"])
app.include_router(users.router, prefix="/users", tags=["users"])
app.include_router(theaters.router, prefix="/theaters", tags=["theaters"])
app.include_router(embedded_movies.router, prefix="/embedded_movies", tags=["embedded_movies"])
app.include_router(sessions.router, prefix="/sessions", tags=["sessions"])
app.include_router(test.router, tags=["test"])
