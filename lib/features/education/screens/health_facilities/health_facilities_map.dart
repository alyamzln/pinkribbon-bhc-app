import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pinkribbonbhc/data/services/map_services.dart';
import 'package:pinkribbonbhc/features/education/models/health_facilities/auto_complete_results.dart';
import 'package:pinkribbonbhc/features/education/models/health_facilities/places_model.dart';
import 'package:pinkribbonbhc/providers/search_places.dart';

class HealthFacilitiesMap extends ConsumerStatefulWidget {
  const HealthFacilitiesMap({super.key});

  @override
  _HealthFacilitiesMapState createState() => _HealthFacilitiesMapState();
}

class _HealthFacilitiesMapState extends ConsumerState<HealthFacilitiesMap> {
  GoogleMapController? _mapController;

  Completer<GoogleMapController> _controller = Completer();

  //Debounce to throttle async calls during search
  Timer? _debounce;

  LatLng? _currentLocation;
  List<Place> _places = [];
  List<Marker> _markers = [];
  TextEditingController _searchController = TextEditingController();

  Set<Marker> _markersSet = Set<Marker>();
  int markerIdCounter = 1;

  void _setMarker(LatLng point) {
    final int counter = markerIdCounter++;
    final Marker marker = Marker(
      markerId: MarkerId('marker_$counter'),
      position: point,
      onTap: () {},
      icon: BitmapDescriptor.defaultMarker,
    );

    setState(() {
      _markers.add(marker);
    });
  }

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<List<Place>> _getNearbyPlaces(LatLng location) async {
    final String apiKey = 'AIzaSyAcL7c6h14swLr9yEQWg8xPqUva56jY6Tg';
    final String baseUrl =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
    final String requestUrl =
        '$baseUrl?location=${location.latitude},${location.longitude}&radius=5000&type=hospital&key=$apiKey';

    final response = await http.get(Uri.parse(requestUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Place> places = (data['results'] as List)
          .map((place) => Place.fromJson(place))
          .toList();
      return places;
    } else {
      throw Exception('Failed to load places');
    }
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      _getCurrentLocation();
    } else {
      // Handle permission denial
    }
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
    _loadNearbyPlaces();
  }

  Future<void> _loadNearbyPlaces() async {
    if (_currentLocation != null) {
      List<Place> places = await _getNearbyPlaces(_currentLocation!);
      setState(() {
        _places = places;
        _markers = places.map((place) {
          return Marker(
            markerId: MarkerId(place.placeId),
            position: LatLng(place.latitude, place.longitude),
            infoWindow: InfoWindow(title: place.name),
          );
        }).toList();
      });
    }
  }

  Future<void> _searchLocation(String query) async {
    final String apiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
    final String baseUrl =
        'https://maps.googleapis.com/maps/api/place/textsearch/json';
    final String requestUrl = '$baseUrl?query=$query&key=$apiKey';

    final response = await http.get(Uri.parse(requestUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'].isNotEmpty) {
        final location = data['results'][0]['geometry']['location'];
        final newLocation = LatLng(location['lat'], location['lng']);
        setState(() {
          _currentLocation = newLocation;
          _searchController.text = query; // Update the search bar text
        });
        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: newLocation, zoom: 14.0),
          ),
        );
        _loadNearbyPlaces(); // Ensure this is called
      }
    } else {
      throw Exception('Failed to load location');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    //Providers
    final allSearchResults = ref.watch(placeResultsProvider);
    final searchFlag = ref.watch(searchToggleProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Health Facilities',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
        ),
        elevation: 20,
        centerTitle: true,
      ),
      body: _currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Positioned.fill(
                  child: GoogleMap(
                    initialCameraPosition:
                        CameraPosition(target: _currentLocation!, zoom: 14.0),
                    onMapCreated: (controller) {
                      _mapController = controller;
                      _controller.complete(controller);
                    },
                    myLocationEnabled: true,
                    markers: Set<Marker>.of(_markers),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  right: 10,
                  child: Column(
                    children: [
                      Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 15.0,
                            ),
                            border: InputBorder.none,
                            hintText: 'Search',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _searchController.text = '';
                                  });
                                },
                                icon: Icon(Icons.close)),
                          ),
                          onChanged: (value) {
                            if (_debounce?.isActive ?? false) {
                              _debounce?.cancel();
                            }
                            _debounce =
                                Timer(Duration(milliseconds: 700), () async {
                              if (value.length > 2) {
                                if (!searchFlag.searchToggle) {
                                  searchFlag.toggleSearch();
                                  // _markers = {};
                                }

                                List<AutoCompleteResult> searchResults =
                                    await MapServices().searchPlaces(value);

                                allSearchResults.setResults(searchResults);
                              } else {
                                List<AutoCompleteResult> emptyList = [];
                                allSearchResults.setResults(emptyList);
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                searchFlag.searchToggle
                    ? allSearchResults.allReturnedResults.length != 0
                        ? Positioned(
                            top: 100.0,
                            left: 15.0,
                            child: Container(
                              height: 200.0,
                              width: screenWidth - 30.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white.withOpacity(0.7),
                              ),
                              child: ListView(
                                children: [
                                  ...allSearchResults.allReturnedResults
                                      .map((e) => buildListItem(e, searchFlag))
                                ],
                              ),
                            ))
                        : Positioned(
                            top: 100.0,
                            left: 15.0,
                            child: Container(
                              height: 200.0,
                              width: screenWidth - 30.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white.withOpacity(0.7),
                              ),
                              child: Center(
                                child: Column(children: [
                                  Text('No results to show',
                                      style: TextStyle(
                                          fontFamily: 'WorkSans',
                                          fontWeight: FontWeight.w400)),
                                  SizedBox(height: 5.0),
                                  Container(
                                    width: 125.0,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        searchFlag.toggleSearch();
                                      },
                                      child: Center(
                                        child: Text(
                                          'Close this',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'WorkSans',
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                    ),
                                  )
                                ]),
                              ),
                            ))
                    : Container(),
                Positioned(
                  bottom: 20,
                  left: 10,
                  right: 10,
                  child: Container(
                    height: 280,
                    width: 300,
                    child: _places.isEmpty
                        ? Center(child: Text('No nearby places found'))
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _places.length,
                            itemBuilder: (context, index) {
                              return _buildPlaceCard(_places[index]);
                            },
                          ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildPlaceCard(Place place) {
    final String photoUrl = place.photoReference != null
        ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${place.photoReference}&key=AIzaSyAcL7c6h14swLr9yEQWg8xPqUva56jY6Tg'
        : 'https://via.placeholder.com/400'; // Placeholder image if no photo is available

    return Card(
      child: Container(
        width: 270,
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              photoUrl,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 8),
            Text(
              place.name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(place.address),
            SizedBox(height: 4),
            Text('Contact: ${place.contactNumber}'),
            SizedBox(height: 4),
            Text('Status: ${place.openNow ? 'Open' : 'Closed'}'),
          ],
        ),
      ),
    );
  }

  Future<void> gotoSearchedPlace(double lat, double lng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 14),
      ),
    );
    _setMarker(LatLng(lat, lng));
    _currentLocation = LatLng(lat, lng); // Update the current location
    _loadNearbyPlaces(); // Load nearby places
  }

  Widget buildListItem(AutoCompleteResult placeItem, searchFlag) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: GestureDetector(
        onTapDown: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onTap: () async {
          var place = await MapServices().getPlace(placeItem.placeId);
          double lat = place['geometry']['location']['lat'];
          double lng = place['geometry']['location']['lng'];
          setState(() {
            _searchController.text = placeItem.description ?? '';
          });
          await gotoSearchedPlace(lat, lng);
          searchFlag.toggleSearch();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.location_on, color: Colors.green, size: 25.0),
            SizedBox(width: 4.0),
            Container(
              height: 40.0,
              width: MediaQuery.of(context).size.width - 75.0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(placeItem.description ?? ''),
              ),
            )
          ],
        ),
      ),
    );
  }
}
