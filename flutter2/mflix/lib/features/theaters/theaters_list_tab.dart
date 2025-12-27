import 'package:flutter/material.dart';
import 'theater_detail_screen.dart';

class TheatersListTab extends StatelessWidget {
  final List<Map<String, dynamic>> theaters;
  const TheatersListTab({required this.theaters, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: theaters.length,
      itemBuilder: (context, index) {
        final theater = theaters[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text(theater['name']?.toString() ?? 'Test'),
            subtitle: Text(
              'State: ${theater['location']?['address']?['state'] ?? '-'}, '
              'Zipcode: ${theater['location']?['address']?['zipcode'] ?? '-'}, '
              'Street: ${theater['location']?['address']?['street1'] ?? '-'}',
            ),
            onTap: () {
              print('[TheatersListTab] Theater tapped: ' + theater.toString());
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => TheaterDetailScreen(
                    theater: theater,
                  ),
                ),
              );
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
