
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'theater_detail_screen.dart';
import 'package:geolocator/geolocator.dart';


class TheatersMapTab extends StatefulWidget {
  final List<Map<String, dynamic>> theaters;
  const TheatersMapTab({required this.theaters, super.key});

  @override
  State<TheatersMapTab> createState() => _TheatersMapTabState();
}

class _TheatersMapTabState extends State<TheatersMapTab> {
  int? _selectedIndex;
  LatLng? _initialCenter;
  bool _loadingLocation = true;

  @override
  void initState() {
    super.initState();
    getCurrentLocationOrDefault().then((center) {
      if (mounted) {
        setState(() {
          _initialCenter = center;
          _loadingLocation = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingLocation || _initialCenter == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return FlutterMap(
      options: MapOptions(
        initialCenter: _initialCenter!,
        initialZoom: 2,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.mflix',
        ),
        MarkerLayer(
          markers: List.generate(widget.theaters.length, (i) => _theaterToMarker(context, widget.theaters[i], i)).whereType<Marker>().toList(),
        ),
      ],
    );
  }

  Marker? _theaterToMarker(BuildContext context, Map<String, dynamic> theater, int index) {
    double? lat;
    double? lng;
    if (theater['location'] is Map &&
        theater['location']['geo'] is Map &&
        theater['location']['geo']['coordinates'] is List) {
      final coords = theater['location']['geo']['coordinates'];
      if (coords.length == 2) {
        lng = coords[0] is num ? coords[0].toDouble() : null;
        lat = coords[1] is num ? coords[1].toDouble() : null;
      }
    }
    if (lat != null && lng != null) {
      final bool isSelected = _selectedIndex == index;
      return Marker(
        width: 28,
        height: 28,
        point: LatLng(lat, lng),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
            _showTheaterDetails(context, theater);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              Icons.location_on,
              color: isSelected ? Colors.blue : Colors.red,
              size: isSelected ? 36 : 28,
              shadows: isSelected
                  ? [Shadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2))]
                  : [],
            ),
          ),
        ),
      );
    }
    return null;
  }

  void _showTheaterDetails(BuildContext context, Map<String, dynamic> theater) {
    final name = theater['name'] ?? 'Unknown Theater';
    final location = theater['location'] ?? {};
    final address = location['address'] ?? {};
    final street = address['street1'] ?? '';
    final city = address['city'] ?? '';
    final state = address['state'] ?? '';
    final zipcode = address['zipcode'] ?? '';
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('$street'),
            Text('$city, $state $zipcode'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Close'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TheaterDetailScreen(theater: theater),
                      ),
                    );
                  },
                  child: const Text('View Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    ).whenComplete(() {
      // Deselect marker when sheet is closed
      if (mounted) {
        setState(() {
          _selectedIndex = null;
        });
      }
    });
  }

  // _getInitialMapCenter removed; now using getCurrentLocationOrDefault in initState

  Future<LatLng> getCurrentLocationOrDefault() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return LatLng(0, 0);

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return LatLng(0, 0);
      }
      if (permission == LocationPermission.deniedForever) return LatLng(0, 0);

      final pos = await Geolocator.getCurrentPosition();
      return LatLng(pos.latitude, pos.longitude);
    } catch (_) {
      return LatLng(0, 0);
    }
  }
}
