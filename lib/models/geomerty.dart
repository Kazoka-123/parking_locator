import 'package:location/models/location_model.dart';
import 'package:location/models/location_model.dart';

class Geometry {
  LocationModel locationModel;
  Geometry({
    required this.locationModel,
  });
  factory Geometry.fromJson(Map<String, dynamic> json) =>
      Geometry(locationModel: LocationModel.fromJson(json['location']));
}
