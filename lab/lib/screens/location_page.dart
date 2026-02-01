import 'package:flutter/material.dart';
import '../models/location.dart';
import '../widgets/title_section.dart';
import '../widgets/button_section.dart';

class LocationPage extends StatelessWidget {
  final Location location;

  const LocationPage({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter layout demo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              location.imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 250,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.image_not_supported,
                        size: 50, color: Colors.grey),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: TitleSection(location: location),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              child: ButtonSection(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 32.0),
              child: Text(
                location.description,
                softWrap: true,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
