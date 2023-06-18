import 'package:location/models/geomerty.dart';

class Place {
  final String name;
  double? rating;
  int? userRating;
  String? vicinity;
  final Geometry geometry;

  Place(
      {required this.name,
      this.rating,
      this.userRating,
      this.vicinity,
      required this.geometry});

  factory Place.fromJson(Map<String, dynamic> json) => Place(
      name: json['name'],
      rating: (json['rating'] != null) ? json['rating'].toDouble() : 1.1,
      userRating: (json['user_ratings_total'] != null)
          ? json['user_ratings_total'].toInt()
          : null,
      vicinity: (json['vicinity'] != null) ? json['vicinity'] : null,
      geometry: Geometry.fromJson(json['geometry']));
}
