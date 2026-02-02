class Location {
  final int id;
  final String name;
  final String address;
  final String description;
  int countStar;
  bool isStarred;
  final String imageUrl;

  Location({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.countStar,
    required this.imageUrl,
    this.isStarred = false,
  });

  static final List<Location> sampleLocations = [
    Location(
      id: 1,
      name: 'Oeschinen Lake Campground',
      address: 'Kandersteg, Switzerland',
      description:
          'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese Alps. A beautiful Alpine lake perfect for summer activities.',
      countStar: 41,
      imageUrl: 'assets/img_1.png',
    ),
    Location(
      id: 2,
      name: 'Matterhorn Mountain',
      address: 'Zermatt, Switzerland',
      description:
          'The iconic pyramid-shaped mountain in the Swiss Alps. One of the highest peaks and most photographed mountains in the world.',
      countStar: 52,
      imageUrl: 'assets/img.png',
    ),
    Location(
      id: 3,
      name: 'Lake Geneva',
      address: 'Geneva, Switzerland',
      description:
          'A crescent-shaped lake shared between Switzerland and France. Known for the famous Jet d\'Eau fountain and beautiful waterfront.',
      countStar: 38,
      imageUrl: 'assets/img_2.png',
    ),
    Location(
      id: 4,
      name: 'Rhine Falls',
      address: 'Schaffhausen, Switzerland',
      description:
          'The largest waterfall in Europe by volume. An impressive natural spectacle with powerful cascading waters.',
      countStar: 45,
      imageUrl: 'assets/img_3.png',
    ),
  ];
}