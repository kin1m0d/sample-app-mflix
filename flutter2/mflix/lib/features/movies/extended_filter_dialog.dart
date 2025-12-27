
import 'package:flutter/material.dart';


class ExtendedFilterDialog extends StatefulWidget {
  final String search;
  final List<String> genres;
  final List<String> selectedGenres;
  final int? selectedYear;
  final List<int> years;
  final double? minRating;
  final List<String> languages;
  final List<String> selectedLanguages;
  final String? rated;
  final List<String> ratedOptions;

  const ExtendedFilterDialog({
    super.key,
    required this.search,
    required this.genres,
    required this.selectedGenres,
    required this.selectedYear,
    required this.years,
    required this.minRating,
    required this.languages,
    required this.selectedLanguages,
    required this.rated,
    required this.ratedOptions,
  });

  @override
  State<ExtendedFilterDialog> createState() => _ExtendedFilterDialogState();
}

class _ExtendedFilterDialogState extends State<ExtendedFilterDialog> {
  late TextEditingController _searchController;
  late String _search;
  late List<String> _selectedGenres;
  int? _selectedYear;
  double? _minRating;
  late List<String> _selectedLanguages;
  String? _rated;

  @override
  void initState() {
    super.initState();
    _search = widget.search;
    _searchController = TextEditingController(text: _search);
    _selectedGenres = List<String>.from(widget.selectedGenres);
    _selectedYear = widget.selectedYear;
    _minRating = widget.minRating;
    _selectedLanguages = List<String>.from(widget.selectedLanguages);
    _rated = widget.rated;
  }

  void _applyFilters() {
    Navigator.of(context).pop({
      'search': _searchController.text,
      'selectedGenres': _selectedGenres,
      'selectedYear': _selectedYear,
      'minRating': _minRating,
      'selectedLanguages': _selectedLanguages,
      'rated': _rated,
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Filter Movies'),
      contentPadding: const EdgeInsets.all(16),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search by title, director...'
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                ...widget.genres.map((genre) => FilterChip(
                  label: Text(genre),
                  selected: _selectedGenres.contains(genre),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedGenres.add(genre);
                      } else {
                        _selectedGenres.remove(genre);
                      }
                    });
                  },
                )),
                DropdownButton<int>(
                  value: _selectedYear,
                  hint: const Text('Year'),
                  items: widget.years.map((y) => DropdownMenuItem(
                    value: y,
                    child: Text(y.toString()),
                  )).toList(),
                  onChanged: (year) => setState(() => _selectedYear = year),
                ),
                InputChip(
                  label: Text('IMDb ≥ ${_minRating?.toStringAsFixed(1) ?? "?"}'),
                  avatar: const Icon(Icons.star, color: Colors.amber, size: 18),
                  onPressed: () async {
                    final newRating = await showDialog<double>(
                      context: context,
                      builder: (ctx) {
                        double temp = _minRating ?? 0;
                        return AlertDialog(
                          title: const Text('Minimum IMDb Rating'),
                          content: StatefulBuilder(
                            builder: (context, setState) => Slider(
                              min: 0,
                              max: 10,
                              divisions: 20,
                              value: temp,
                              label: temp.toStringAsFixed(1),
                              onChanged: (v) => setState(() => temp = v),
                            ),
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                            TextButton(onPressed: () => Navigator.pop(ctx, temp), child: const Text('OK')),
                          ],
                        );
                      },
                    );
                    if (newRating != null) setState(() => _minRating = newRating);
                  },
                  onDeleted: _minRating != null ? () => setState(() => _minRating = null) : null,
                ),
                ...widget.languages.map((lang) => FilterChip(
                  label: Text(lang),
                  selected: _selectedLanguages.contains(lang),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedLanguages.add(lang);
                      } else {
                        _selectedLanguages.remove(lang);
                      }
                    });
                  },
                )),
                DropdownButton<String>(
                  value: _rated,
                  hint: const Text('Rated'),
                  items: widget.ratedOptions.map((r) => DropdownMenuItem(
                    value: r,
                    child: Text(r),
                  )).toList(),
                  onChanged: (r) => setState(() => _rated = r),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _applyFilters,
              child: const Text('Search'),
            ),
          ],
        ),
      ],
    );
  }
}
