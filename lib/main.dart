import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/screen/search.dart';
import 'package:location/services/geolocator_services.dart';
import 'package:location/services/places_service.dart';
import 'package:provider/provider.dart';

import 'models/place.dart';

final placeServices = PlaceService();

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => GeolocatorServices()),
    ChangeNotifierProvider(create: (context) => PlaceService()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Search(),
    );
  }
}
