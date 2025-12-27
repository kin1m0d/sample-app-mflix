## Movie Details Screen UX/UI Specification

Design a Flutter movie details screen that displays the following fields from the movie data structure in a clean, modern, and user-friendly way:

### Widget Structure

- **Scaffold**
	- AppBar: Show the movie title.
	- SingleChildScrollView (with EdgeInsets.all(16) padding)
		- Column (crossAxisAlignment: CrossAxisAlignment.start)
			- (Optional) Poster/Image: If available, display at the top, centered, with a placeholder if missing.
			- Row:
				- Title (large, bold)
				- Year (smaller, secondary text)
			- Wrap or Row: Genres as Chips (e.g., “Drama”, “Short”)
			- Row (mainAxisAlignment: spaceBetween):
				- IMDb rating (star icon + value)
				- Runtime (clock icon + “14 min”)
				- Rated (badge, e.g., “G”)
			- SizedBox(height: 16)
			- Section: Plot
				- “Plot” (section header, bold)
				- Full plot or plot summary (regular text)
			- SizedBox(height: 16)
			- Section: Details (Card or ExpansionTile)
				- ListTile: Directors (comma-separated)
				- ListTile: Cast (comma-separated, collapsible if long)
				- ListTile: Languages (comma-separated)
				- ListTile: Released (formatted date, e.g., “Dec 1, 1909”)
				- ListTile: Countries (comma-separated)
				- ListTile: Awards (text summary, e.g., “1 win.”)
			- SizedBox(height: 16)
			- Section: Comments/Reviews (if available)
				- Row: Number of comments, “View/Add Comments” button

### Visual/UX Guidelines

- Use icons for IMDb rating (star), runtime (clock), and awards (trophy/medal).
- Use Chips for genres and languages for a modern look.
- Group related info in Cards or ExpansionTiles for readability.
- Use section headers (e.g., “Plot”, “Details”, “Cast”) for structure.
- If the cast or comments are long, make them collapsible (ExpansionTile).
- Use a placeholder image if no poster is available.
- Ensure all text is readable and not cramped; use SizedBox for spacing.
- Use theme colors for Chips and badges for consistency.

### Example Widget Tree

```
Scaffold
	AppBar (title: movie['title'])
	SingleChildScrollView
		Padding (all: 16)
			Column
				[Poster Image]
				Row [Title, Year]
				Wrap [Genre Chips]
				Row [IMDb, Runtime, Rated]
				Section: Plot
				Section: Details (Card/ListTiles)
				Section: Comments/Reviews
```

### Data Mapping

- Title: movie['title']
- Year: movie['year']
- Genres: movie['genres'] (List<String>)
- Runtime: movie['runtime'] (int, in minutes)
- Cast: movie['cast'] (List<String>)
- Plot: movie['fullplot'] or movie['plot']
- Directors: movie['directors'] (List<String>)
- Languages: movie['languages'] (List<String>)
- Released: movie['released'] (date, format nicely)
- Countries: movie['countries'] (List<String>)
- Rated: movie['rated']
- IMDb rating: movie['imdb']['rating']
- Awards: movie['awards']['text']
- Comments: movie['num_mflix_comments']
