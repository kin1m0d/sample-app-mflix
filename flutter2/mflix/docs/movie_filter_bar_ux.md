## Movie FilterBar UX/UI Specification

Design a modern, user-friendly FilterBar for a movie list screen in Flutter. The FilterBar should allow users to quickly find and filter movies using the most relevant attributes, while keeping the interface clean and intuitive.

### Widget Structure

- **Column**
	- **Row** (mainAxisAlignment: spaceBetween)
		- **Expanded**
			- **TextField**
				- prefixIcon: Icon(Icons.search)
				- hintText: "Search by title, director..."
				- onChanged: (String value) => filter movies as user types
		- **IconButton** (icon: Icons.tune)
			- Opens advanced filters (e.g., showModalBottomSheet or ExpansionPanel)
	- **Wrap** (spacing: 8)
		- **Filter Chips** for common attributes:
			- Genre (multi-select)
			- Year (dropdown or range, e.g., 2000–2025)
			- IMDb Rating (slider or min value chip)
			- Language (dropdown or chips)
			- Rated (dropdown: G, PG, etc.)
		- **Active Filter Chips**
			- Show currently applied filters as removable chips (e.g., "Genre: Drama ×")

### Filterable Movie Attributes

1. **Title** (TextField, main search)
2. **Genre** (multi-select chips or dropdown)
3. **Year** (dropdown, range slider, or input)
4. **IMDb Rating** (slider or min value chip)
5. **Director** (TextField or dropdown)
6. **Language** (dropdown or chips)
7. **Rated** (dropdown: G, PG, etc.)

### UX Guidelines

- Place the FilterBar at the top, always visible.
- Use a search field with a search icon and clear placeholder.
- Allow combining multiple filters (search + genre + year, etc.).
- Show active filters as removable chips for clarity.
- Hide advanced filters behind an icon or expansion for a clean look.
- Provide instant feedback (filter as you type/select).
- Keep the UI uncluttered and mobile-friendly.

### Example Widget Tree

```
Column
	Row
		Expanded
			TextField (search)
		IconButton (advanced filters)
	Wrap (filter chips)
		[GenreChip, YearChip, RatingChip, LanguageChip, RatedChip, ...]
		[ActiveFilterChip, ...]
```

### Prompt Example

"Design a Flutter FilterBar for movies with a search TextField, filter chips for genre, year, rating, language, and rated, and an advanced filter button. Show active filters as removable chips. The FilterBar should be clean, responsive, and provide instant feedback as the user types or selects filters."
