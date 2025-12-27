

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


class TheaterDetailScreen extends StatelessWidget {
  final Map<String, dynamic> theater;
  const TheaterDetailScreen({required this.theater, super.key});

  @override
  Widget build(BuildContext context) {
    print('[TheaterDetailScreen] Theater object: ' + theater.toString());
    double? lat;
    double? lng;
    String locationDisplay = '';
    // Try to extract coordinates from theater['location']['geo']['coordinates']
    if (theater['location'] is Map &&
        theater['location']['geo'] is Map &&
        theater['location']['geo']['coordinates'] is List) {
      final coords = theater['location']['geo']['coordinates'];
      if (coords.length == 2) {
        lng = coords[0] is num ? coords[0].toDouble() : null;
        lat = coords[1] is num ? coords[1].toDouble() : null;
        locationDisplay = 'Lat: ${lat?.toStringAsFixed(6) ?? '-'}, Lng: ${lng?.toStringAsFixed(6) ?? '-'}';
      }
    } else if (theater['location'] is String) {
      locationDisplay = theater['location'];
    } else {
      locationDisplay = 'Unknown';
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Theater Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('_id: ${theater['_id']?.toString() ?? 'Unknown'}'),
            Text('Theater ID: ${theater['theaterId']?.toString() ?? 'Unknown'}'),
            Text('Location Address: ${theater['location']['address']?.toString() ?? 'Unknown'}'),
            Text('Location Geo: ${theater['location']['geo']?.toString() ?? 'Unknown'}'),
            const SizedBox(height: 8),
            if (lat != null && lng != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                height: 200,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(lat, lng),
                    initialZoom: 15,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.mflix',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 40,
                          height: 40,
                          point: LatLng(lat, lng),
                          child: Icon(Icons.location_on, color: Colors.red, size: 40),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ] else ...[
              const SizedBox(height: 24),
              const Text('No map location available.', style: TextStyle(color: Colors.grey)),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
