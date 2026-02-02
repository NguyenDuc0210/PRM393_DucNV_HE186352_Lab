import 'package:flutter/material.dart';
import '../models/location.dart';
import '../widgets/button_section.dart';

class LocationPage extends StatefulWidget {
  final Location location;

  const LocationPage({super.key, required this.location});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  bool showDetails = false;

  void toggleStar() {
    setState(() {
      widget.location.countStar++;
      widget.location.isStarred = true;
    });
  }

  void toggleDetails() {
    setState(() {
      showDetails = !showDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              widget.location.imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              cacheWidth: 800,
              filterQuality: FilterQuality.medium,
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
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.location.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.location.address,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: toggleStar,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.red,
                              size: 26,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.location.countStar.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: ButtonSection(),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.location.description,
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Center(
                child: OutlinedButton.icon(
                  onPressed: toggleDetails,
                  icon: Icon(
                    showDetails ? Icons.expand_less : Icons.expand_more,
                  ),
                  label: Text(showDetails ? 'Hide Details' : 'View Details'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
            if (showDetails) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(thickness: 1),
                    const SizedBox(height: 16),
                    const Text(
                      'Detailed Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailSection(
                      'History',
                      'This location has a rich history dating back centuries. '
                          'It has been a popular destination for travelers and nature '
                          'enthusiasts from around the world.',
                      Icons.history,
                    ),
                    _buildDetailSection(
                      'Activities',
                      'Visitors can enjoy hiking, photography, wildlife watching, '
                          'and seasonal sports. Well-maintained trails for all skill levels.',
                      Icons.hiking,
                    ),
                    _buildDetailSection(
                      'Best Time to Visit',
                      'Best visited during spring and summer months (May to September). '
                          'Winter offers snow-covered landscapes.',
                      Icons.calendar_today,
                    ),
                    _buildDetailSection(
                      'Facilities',
                      'Modern facilities including visitor centers, restrooms, parking, '
                          'restaurants and accommodation options.',
                      Icons.apartment,
                    ),
                    _buildDetailSection(
                      'Getting There',
                      'Accessible by car, public transportation, or organized tours. '
                          'Regular bus and train services available.',
                      Icons.directions_car,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String content, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}