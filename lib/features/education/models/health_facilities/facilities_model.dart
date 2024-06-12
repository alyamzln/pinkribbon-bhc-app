import 'package:cloud_firestore/cloud_firestore.dart';

class Facility {
  final String id;
  final String name;
  final String region;
  final String address;
  final String contactNum;
  final String website;
  final GeoPoint coordinates;

  Facility({
    required this.id,
    required this.name,
    required this.region,
    required this.address,
    required this.contactNum,
    required this.website,
    required this.coordinates,
  });

  factory Facility.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Facility(
      id: doc.id,
      name: data['name'] ?? '',
      region: data['region'] ?? '',
      address: data['address'] ?? '',
      contactNum: data['contactNum'] ?? '',
      website: data['website'] ?? '',
      coordinates: data['coordinates'],
    );
  }
}
