

class MovieFilterState {
  String search;
  List<String> selectedGenres;
  List<String> genres;
  int? selectedYear;
  List<int> years;
  double? minRating;
  List<String> selectedLanguages;
  List<String> languages;
  String? rated;
  List<String> ratedOptions;

  MovieFilterState({
    this.search = '',
    List<String>? selectedGenres,
    List<String>? genres,
    this.selectedYear,
    List<int>? years,
    this.minRating,
    List<String>? selectedLanguages,
    List<String>? languages,
    this.rated,
    List<String>? ratedOptions,
  })  : selectedGenres = selectedGenres ?? [],
        genres = genres ?? [],
        selectedLanguages = selectedLanguages ?? [],
        languages = languages ?? [],
        years = years ?? [],
        ratedOptions = ratedOptions ?? [];


  MovieFilterState copyWith({
    String? search,
    List<String>? selectedGenres,
    List<String>? genres,
    int? selectedYear,
    List<int>? years,
    double? minRating,
    List<String>? selectedLanguages,
    List<String>? languages,
    String? rated,
    List<String>? ratedOptions,
  }) {
    return MovieFilterState(
      search: search ?? this.search,
      selectedGenres: selectedGenres ?? List<String>.from(this.selectedGenres),
      genres: genres ?? List<String>.from(this.genres),
      selectedYear: selectedYear ?? this.selectedYear,
      years: years ?? List<int>.from(this.years),
      minRating: minRating ?? this.minRating,
      selectedLanguages: selectedLanguages ?? List<String>.from(this.selectedLanguages),
      languages: languages ?? List<String>.from(this.languages),
      rated: rated ?? this.rated,
      ratedOptions: ratedOptions ?? List<String>.from(this.ratedOptions),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'search': search,
      'selectedGenres': selectedGenres,
      'genres': genres,
      'selectedYear': selectedYear,
      'years': years,
      'minRating': minRating,
      'selectedLanguages': selectedLanguages,
      'languages': languages,
      'rated': rated,
      'ratedOptions': ratedOptions,
    };
  }

  factory MovieFilterState.fromMap(Map<String, dynamic> map) {
    return MovieFilterState(
      search: map['search'] ?? '',
      selectedGenres: List<String>.from(map['selectedGenres'] ?? []),
      genres: List<String>.from(map['genres'] ?? []),
      selectedYear: map['selectedYear'],
      years: List<int>.from(map['years'] ?? []),
      minRating: map['minRating'],
      selectedLanguages: List<String>.from(map['selectedLanguages'] ?? []),
      languages: List<String>.from(map['languages'] ?? []),
      rated: map['rated'],
      ratedOptions: List<String>.from(map['ratedOptions'] ?? []),
    );
  }
}