import 'dart:async';
import 'dart:convert';
import 'package:buyers/constants/custom_routes.dart';
import 'package:buyers/constants/custom_snackbar.dart';
import 'package:buyers/constants/custom_text.dart';
import 'package:buyers/constants/google_api_key.dart';
import 'package:buyers/payment/chapa_payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:get_storage/get_storage.dart';
import 'package:buyers/constants/custome_button.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController phoneController = TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  LocationData? _currentPosition;
  LatLng? _latLong;
  geocoding.Placemark? _placeMark;
  Set<Polyline> _polylines = {};
  final store = GetStorage();
  List<LatLng> deliveryRange = [];

  @override
  void initState() {
    _getUserLocation();
    _fetchDeliveryRangePoints();
    super.initState();
  }

  Future<LocationData> _getLocationPermission() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return Future.error('Service not enabled');
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return Future.error('Permission Denied');
      }
    }

    locationData = await location.getLocation();
    return locationData;
  }

  _getUserLocation() async {
    _currentPosition = await _getLocationPermission();
    _goToCurrentPosition(
        LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!));
    // Set initial _latLong value
    _latLong =
        LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);
  }

  _fetchDeliveryRangePoints() async {
    try {
      var collection =
          await FirebaseFirestore.instance.collection('delivery_ranges').get();
      if (collection.docs.isNotEmpty) {
        var deliveryRangeData = collection.docs[0].data();
        List<dynamic> pointsData = deliveryRangeData['points'];

        List<LatLng> points = pointsData.map<LatLng>((point) {
          return LatLng(point['latitude'], point['longitude']);
        }).toList();

        setState(() {
          deliveryRange = points;
        });
      }
    } catch (e) {
      print("Error fetching delivery range points: $e");
    }
  }

  getUserAddress() async {
    List<geocoding.Placemark> placemarks = await geocoding
        .placemarkFromCoordinates(_latLong!.latitude, _latLong!.longitude);
    setState(() {
      _placeMark = placemarks.first;
    });
  }

  void _fetchAndDisplayRoute(LatLng source, LatLng destination) async {
    List<LatLng> polylinePoints = await _getPolylineRoute(source, destination);

    setState(() {
      _polylines.clear();
      _polylines.add(Polyline(
        polylineId: PolylineId('route'),
        points: polylinePoints,
        color: Colors.blue,
        width: 5,
      ));
    });
  }

  Future<List<LatLng>> _getPolylineRoute(
      LatLng source, LatLng destination) async {
    String apiKey = GOOGLE_MAPS_API_KEY;
    String apiUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${source.latitude},${source.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final List<dynamic> routes = data['routes'];
        if (routes.isNotEmpty) {
          final List<dynamic> legs = routes[0]['legs'];
          if (legs.isNotEmpty) {
            final List<dynamic> steps = legs[0]['steps'];

            List<LatLng> polylinePoints = [];

            for (int i = 0; i < steps.length; i++) {
              final Map<String, dynamic> polyline =
                  steps[i]['polyline']['points'];
              List<LatLng> decodedPolyline = decodePolyline(
                  polyline as String); // Helper function to decode polyline

              polylinePoints.addAll(decodedPolyline);
            }

            return polylinePoints;
          }
        }
      }
    }

    return [];
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> polylinePoints = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      double latDouble = lat / 1e5;
      double lngDouble = lng / 1e5;

      LatLng position = LatLng(latDouble, lngDouble);
      polylinePoints.add(position);
    }

    return polylinePoints;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.black12,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _placeMark != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _placeMark!.name ?? _placeMark!.locality!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text('${_placeMark!.locality!} '),
                                      Text(_placeMark!.subAdministrativeArea !=
                                              null
                                          ? '${_placeMark!.subAdministrativeArea!}, '
                                          : ''),
                                    ],
                                  ),
                                  Text(
                                      '${_placeMark!.administrativeArea!}, ${_placeMark!.country!}, ${_placeMark!.postalCode!}'),
                                ],
                              )
                            : Container(),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: phoneController,
                                decoration: InputDecoration(
                                  hintText: 'phoneNumber'.tr,
                                ),
                                keyboardType: TextInputType
                                    .phone, // Set the keyboard type here
                              ),
                            ),
                            SizedBox(width: 10),
                            CustomButton(
                              width: 120,
                              title: 'setAddress'.tr,
                              onPressed: () {
                                if (phoneController.text.isEmpty) {
                                  customSnackbar(
                                    context: context,
                                    message: 'Please put your phone address',
                                  );
                                } else {
                                  String name = '${_placeMark!.name},';
                                  String locality = '${_placeMark!.locality},';
                                  String adminArea =
                                      '${_placeMark!.administrativeArea},';
                                  String subAdminArea =
                                      '${_placeMark!.subAdministrativeArea},';
                                  String country = '${_placeMark!.country},';
                                  String pin = '${_placeMark!.postalCode},';
                                  String address =
                                      '$name, $locality, $subAdminArea,$adminArea, $country,$pin,';
                                  double latitude = _latLong!.latitude!;
                                  double longitude = _latLong!.longitude!;
                                  store.write('address', address);
                                  store.write('latitude', latitude.toString());
                                  store.write(
                                      'longitude', longitude.toString());
                                  store.write(
                                      'phoneNumber', phoneController.text);

                                  _fetchAndDisplayRoute(
                                    LatLng(
                                      _currentPosition!.latitude!,
                                      _currentPosition!.longitude!,
                                    ),
                                    _latLong!,
                                  );

                                  _showBottomSheet(context);
                                }
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * .70,
                    decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey))),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GoogleMap(
                              myLocationEnabled: true,
                              myLocationButtonEnabled: true,
                              compassEnabled: false,
                              mapType: MapType.terrain,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(9.422967, 42.037149),
                                zoom: 13,
                              ),
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                              },
                              onCameraMove: (CameraPosition position) {
                                setState(() {
                                  _latLong = position.target;
                                });
                              },
                              onCameraIdle: () {
                                getUserAddress();
                              },
                              polylines: _polylines,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.transparent,
                            child: Icon(
                              Icons.location_on,
                              size: 40,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _goToCurrentPosition(LatLng latlng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(latlng.latitude, latlng.longitude),
      zoom: 13,
    )));
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'deliveryAddress'.tr,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              text(title: 'Phone Number: ${phoneController.text}'),
              FittedBox(
                child: Text(
                  store.read('address'.toString()) ?? '',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              Row(
                children: [
                  text(title: 'Latitude :  '),
                  Text(
                    store.read('latitude'.toString()) ?? '',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              Row(
                children: [
                  text(title: 'Longitude :  '),
                  Text(
                    store.read('longitude') ?? '',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              _isAddressWithinRange(_latLong!)
                  ? Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            child: CustomButton(
                              color: Colors.green,
                              width: 130,
                              title: 'conform'.tr,
                              onPressed: () {
                                Routes.instance.push(
                                    widget: ChapaPayment(title: 'Belkis'),
                                    context: context);
                                // Routes.instance
                                //     .push(widget: FinishedScreen(productModel: ProductModel(),), context: context);
                              },
                            ),
                          ),
                          Flexible(
                            child: CustomButton(
                              width: 130,
                              color: Colors.deepOrange.shade300,
                              title: 'change'.tr,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : Row(
                      children: [
                        Flexible(
                          child: CustomButton(
                            width: 130,
                            color: Colors.deepOrange.shade300,
                            title: 'You are out of delivery range'.tr,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
              SizedBox(height: 50)
            ],
          ),
        );
      },
    );
  }

  bool _isAddressWithinRange(LatLng address) {
    // Use the Polygon class to check if the given address is within the delivery range
    return PolygonUtil.containsLocation(
      LatLng(
        address.latitude,
        address.longitude,
      ),
      deliveryRange,
    );
  }
}

class PolygonUtil {
  static bool containsLocation(LatLng point, List<LatLng> polygon) {
    if (polygon.length < 3) {
      return false; // Invalid polygon
    }

    bool inPoly = false;
    for (int i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
      if ((polygon[i].latitude > point.latitude) !=
              (polygon[j].latitude > point.latitude) &&
          point.longitude <
              (polygon[j].longitude - polygon[i].longitude) *
                      (point.latitude - polygon[i].latitude) /
                      (polygon[j].latitude - polygon[i].latitude) +
                  polygon[i].longitude) {
        inPoly = !inPoly;
      }
    }
    return inPoly;
  }
}
