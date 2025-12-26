# Flutter App Wireframe (MFlix)

This wireframe outlines the main navigation, screens, and key UI elements for a Flutter app that connects to a FastAPI backend for full CRUD operations on MongoDB Atlas sample_mflix collections. Use this as a prompt or blueprint for implementation.

---

## Main Scaffold

- **AppBar:** "MFlix App"
- **Drawer** or **BottomNavigationBar** for navigation:
	- Movies
	- Comments
	- Users
	- Theaters
	- Embedded Movies
	- Sessions
- **Settings** (for API URL config)

---

## Movies (repeat similar for other collections)

### MoviesListScreen
- AppBar: "Movies"
- Filter Bar: Search by title, year, etc.
- Pull-to-refresh
- ListView.builder:
	- MovieCard (title, year, short info)
	- [Edit] [Delete] buttons on each card
- FloatingActionButton: [+ Add Movie]
- Loading indicator (centered if loading)
- Error message (SnackBar or banner)

---

### MovieDetailScreen
- AppBar: "Movie Details"
- Card/ListTile:
	- Title
	- Year
	- Director
	- Cast
	- Description
	- etc.
- [Edit] button (navigates to MovieFormScreen)
- [Delete] button (with confirmation dialog)
- Back button

---

### MovieFormScreen (Create/Edit)
- AppBar: "Add/Edit Movie"
- Form:
	- TextFormField: Title (with validation)
	- TextFormField: Year (with validation)
	- TextFormField: Director
	- etc.
- [Save] button (validates and submits)
- [Cancel] button
- Loading indicator (on submit)
- Error message (if validation or API fails)

---

## Comments, Users, Theaters, Embedded Movies, Sessions

- Each has:
	- ListScreen (with filters, list, add button)
	- DetailScreen (full info, edit/delete)
	- FormScreen (create/edit with validation)

---

## Settings Screen

- AppBar: "Settings"
- TextField: API Base URL
- [Save] button

---

## Reusable Widgets

- LoadingIndicator
- ErrorMessage
- FilterBar
- ItemCard (for each collection)

---

## Navigation Flow

- Drawer/BottomNav → ListScreen (per collection)
- ListScreen → DetailScreen (on item tap)
- ListScreen/DetailScreen → FormScreen (on add/edit)
- Settings accessible from Drawer

---

This wireframe provides a clear, modular, and user-friendly structure for your app, making it easy to implement and scale. For a visual wireframe, use a tool like Figma, but this text version is ideal for planning and as a prompt for Copilot or other AI tools.
