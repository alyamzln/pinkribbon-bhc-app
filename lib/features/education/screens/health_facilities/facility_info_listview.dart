import 'package:flutter/material.dart';
import 'package:pinkribbonbhc/data/repositories/health_facilities/facilities_repository.dart';
import 'package:pinkribbonbhc/features/education/models/health_facilities/facilities_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class FacilityInfoListView extends StatefulWidget {
  final String region;

  const FacilityInfoListView({super.key, required this.region});

  @override
  _FacilityInfoListViewState createState() => _FacilityInfoListViewState();
}

class _FacilityInfoListViewState extends State<FacilityInfoListView> {
  late Future<List<Facility>> _facilitiesFuture;

  @override
  void initState() {
    super.initState();
    _facilitiesFuture =
        FacilitiesRepository().fetchHealthcareFacilitiesByRegion(widget.region);
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _callNumber(String number) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not call $number';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Health Facilities in ${widget.region}',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
        ),
        elevation: 20,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Facility>>(
        future: _facilitiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No facilities found in this region'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Facility facility = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(facility.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(facility.address),
                        SizedBox(height: 4),
                        Text('Contact: ${facility.contactNum}'),
                        SizedBox(height: 4),
                        GestureDetector(
                          onTap: () async {
                            if (await canLaunchUrl(
                                Uri.parse(facility.website))) {
                              await launchUrl(Uri.parse(facility.website));
                            } else {
                              throw 'Could not launch ${facility.website}';
                            }
                          },
                          child: Text(
                            'Website: ${facility.website}',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    leading: Icon(Icons.local_hospital),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.phone),
                          onPressed: () => _callNumber(facility.contactNum),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Handle navigation or additional actions here
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
