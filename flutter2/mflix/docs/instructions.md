Create a Flutter app that connects to a FastAPI backend providing full CRUD (Create, Read, Update, Delete) operations for a MongoDB Atlas sample_mflix database. The backend exposes REST endpoints for the following collections: movies, comments, users, theaters, embedded_movies, and sessions.

Backend API details:

Base URL: http://127.0.0.1:8888/
Endpoints (all support JSON):
/movies, /comments, /users, /theaters, /embedded_movies, /sessions
Each endpoint supports:
GET (list, with optional filters)
GET by ID
POST (create)
PUT/PATCH (update by ID)
DELETE (delete by ID)
All endpoints use MongoDB ObjectId as the primary key (_id, as a string).
Example: GET /movies, GET /movies/{id}, POST /movies, PUT /movies/{id}, DELETE /movies/{id}
Input and output schemas follow the backend’s Pydantic models (see OpenAPI docs at /docs).
Flutter app requirements:

Use Dart’s http package (or Dio) for REST API calls.
Create Dart models matching the backend’s JSON structure for each collection.
Implement screens for:
Listing, viewing, creating, editing, and deleting for each collection (movies, comments, users, theaters, embedded_movies, sessions).
Filtering lists by standard fields (e.g., movie title, user email).
Use forms for creating and editing, with validation matching backend requirements.
Show error messages for failed requests (e.g., 404, 500).
Display loading indicators during network calls.
Use a clean, modern UI (Material or Cupertino).
Make the API base URL configurable (for local or remote backend).
(Optional) Use provider, bloc, or riverpod for state management.
Instructions:

Start by generating Dart data models from the backend’s OpenAPI schema (http://127.0.0.1:8888/openapi.json).
Scaffold the app with navigation for each collection.
Implement API service classes for each endpoint.
Build UI for CRUD operations for each collection.
Test all endpoints with real data.
Document how to configure the API URL and run the app.
Reference:

FastAPI OpenAPI docs: http://127.0.0.1:8888/docs