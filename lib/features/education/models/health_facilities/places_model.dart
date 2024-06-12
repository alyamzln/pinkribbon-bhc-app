class Place {
  final String name;
  final String address;
  final String contactNumber;
  final bool openNow;
  final double latitude;
  final double longitude;
  final String placeId;
  final String? photoReference;

  Place({
    required this.name,
    required this.address,
    required this.contactNumber,
    required this.openNow,
    required this.latitude,
    required this.longitude,
    required this.placeId,
    this.photoReference,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['name'],
      address: json['vicinity'],
      contactNumber: json['formatted_phone_number'] ?? 'N/A',
      openNow: json['opening_hours']?['open_now'] ?? false,
      latitude: json['geometry']['location']['lat'],
      longitude: json['geometry']['location']['lng'],
      placeId: json['place_id'],
      photoReference: json['photos'] != null && json['photos'].isNotEmpty
          ? json['photos'][0]['photo_reference']
          : null,
    );
  }
}
