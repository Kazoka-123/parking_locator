class LocationModel {
  final double lat;
  final double lng;

  LocationModel({required this.lat, required this.lng});
  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        lat: json['lat'],
        lng: json['lng'],
      );
}
