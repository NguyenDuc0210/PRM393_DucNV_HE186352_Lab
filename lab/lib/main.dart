import 'package:flutter/material.dart';
import 'models/location.dart';
import 'screens/location_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const location = Location(
      id: 1,
      name: 'Oeschinen Lake Campground',
      address: 'Kandersteg, Switzerland',
      description:
      'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese '
          'Alps. Situated 1,578 meters above sea level, it is one of the '
          'larger Alpine Lakes. A gondola ride from Kandersteg, followed by a '
          'half-hour walk through pastures and pine forest, leads you to the '
          'lake, which warms to 20 degrees Celsius in the summer. Activities '
          'enjoyed here include rowing, and riding the summer toboggan run.',
      countStar: 41,
      imageUrl: 'https://i.pinimg.com/originals/1f/28/12/1f2812970ce04994f1bb011103c14b89.jpg',
    );

    return MaterialApp(
      title: 'Flutter layout demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LocationPage(location: location),
    );
  }
}
