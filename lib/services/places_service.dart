import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:location/models/place.dart';

class PlaceService extends ChangeNotifier {
  final key = 'AIzaSyB3FXon2BMbr-Yku-XVKvA2AFbBQ154JU8';
  List<Place> data = [];

  Future<List<Place>> getPlace(double lat, double lng) async {
    print(lat);
    print(lng);
    var response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${lat}, ${lng}&type=parking&rankby=distance&key=AIzaSyB3FXon2BMbr-Yku-XVKvA2AFbBQ154JU8'));
    var json = jsonDecode(response.body);
    var jsonResult = json['results'] as List;
    data = jsonResult.map((place) => Place.fromJson(place)).toList();
    print(data[0].name);
    notifyListeners();
    return data;
  }
}
