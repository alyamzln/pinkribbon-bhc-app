import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinkribbonbhc/common/styles/color_filters.dart';
import 'package:pinkribbonbhc/common/widgets/login_signup/form_divider.dart';
import 'package:pinkribbonbhc/features/education/screens/health_facilities/facility_info_listview.dart';
import 'package:pinkribbonbhc/utils/constants/image_strings.dart';

class HealthFacilitiesList extends StatelessWidget {
  HealthFacilitiesList({super.key});

  final Map<String, String> regionImages = {
    'Johor': TImages.johor,
    'Kedah': TImages.kedah,
    'Kelantan': TImages.kelantan,
    'Kuala Lumpur': TImages.kualalumpur,
    'W.P. Labuan': TImages.labuan,
    'Langkawi': TImages.langkawi,
    'Melaka': TImages.melaka,
    'Negeri Sembilan': TImages.negeriSembilan,
    'Pahang': TImages.pahang,
    'Penang': TImages.penang,
    'Perak': TImages.perak,
    'Perlis': TImages.perlis,
    'Putrajaya': TImages.putrajaya,
    'Sabah': TImages.sabah,
    'Sarawak': TImages.sarawak,
    'Selangor': TImages.selangor,
    'Terengganu': TImages.terengganu,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hospitals and Support Groups',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
        ),
        elevation: 20,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for healthcare facility',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              ),
            ),
          ),
          TFormDivider(dividerText: 'Or Search by Region'),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: regionImages.length,
              itemBuilder: (context, index) {
                final region = regionImages.keys.elementAt(index);
                final image = regionImages.values.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Ink.image(
                            image: AssetImage(image),
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.3),
                              BlendMode.darken,
                            ),
                            child: InkWell(
                              onTap: () {
                                Get.to(
                                    () => FacilityInfoListView(region: region));
                              },
                            ),
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                          Text(
                            region,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      )),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
