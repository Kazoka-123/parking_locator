import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/services/geolocator_services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constant.dart';
import '../services/places_service.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locationServices =
        Provider.of<GeolocatorServices>(context, listen: false);
    final placeServices = Provider.of<PlaceService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps'),
      ),
      body: FutureBuilder(
        future: locationServices.determinePosition(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else {
            final currentPosition = snapshot.data;
            print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<${currentPosition}");
            return FutureBuilder(
                future: placeServices.getPlace(
                    currentPosition!.latitude, currentPosition.longitude),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('${snapshot.error}'),
                    );
                  } else {
                    final data = snapshot.data;
                    print('>>>>>>>>>>>>>>>>>>>>>>${data}');
                    return Column(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height / 2,
                          width: MediaQuery.of(context).size.width,
                          child: GoogleMap(
                            myLocationEnabled: true,
                            mapType: MapType.normal,
                            zoomControlsEnabled: true,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(currentPosition!.latitude,
                                  currentPosition!.longitude),
                              zoom: 16.0,
                            ),
                            zoomGesturesEnabled: true,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                            child: ListView.builder(
                                itemCount: data!.length,
                                itemBuilder: (context, index) {
                                  return FutureProvider(
                                    create: (context) =>
                                        locationServices.getDistance(
                                            currentPosition.latitude,
                                            currentPosition.longitude,
                                            data[index]
                                                .geometry
                                                .locationModel
                                                .lat,
                                            data[index]
                                                .geometry
                                                .locationModel
                                                .lng),
                                    initialData: null,
                                    child: Card(
                                      child: ListTile(
                                        title: Text('${data[index].name}'),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Row(
                                              children: [
                                                RatingBarIndicator(
                                                    rating: data[index].rating!,
                                                    itemCount: 5,
                                                    itemSize: 10.0,
                                                    direction: Axis.horizontal,
                                                    itemBuilder: (context,
                                                            index) =>
                                                        Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        ))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Consumer<double?>(builder:
                                                (context, meters, widget) {
                                              return (meters != null)
                                                  ? Text(
                                                      '${data[index].vicinity}\u00b7 ${(meters / 1609).round()}')
                                                  : Container();
                                            })
                                          ],
                                        ),
                                        trailing: IconButton(
                                            onPressed: () {
                                              _launchGoogleMaps(
                                                  data[index]
                                                      .geometry
                                                      .locationModel
                                                      .lat,
                                                  data[index]
                                                      .geometry
                                                      .locationModel
                                                      .lng);
                                            },
                                            icon: Icon(
                                              Icons.directions,
                                              color: Colors.blue,
                                            )),
                                      ),
                                    ),
                                  );
                                }))
                      ],
                    );
                  }
                });
          }
        },
      ),
    );
  }

  // void _launchUrl(double lat, double long) async {
  //   final url =
  //       "https://maps.googleapis.com/maps/api/place/textsearch/json?query=$lat,$long&key=$apiKey";
  //   if (!await launchUrl(
  //       Uri.parse(
  //         url,
  //       ),
  //       mode: LaunchMode.externalApplication)) {
  //     throw 'Can not launch ${url}';
  //   }
  //   ;
  // }
  void _launchGoogleMaps(double lat, double long) async {
    final query = Uri.encodeComponent('$lat,$long');
    final url = 'https://www.google.com/maps/search/?api=1&query=$query';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch Google Maps with the provided location.';
    }
  }
}
