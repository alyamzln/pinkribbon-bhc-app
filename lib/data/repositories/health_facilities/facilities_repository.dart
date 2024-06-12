import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:pinkribbonbhc/features/education/models/health_facilities/facilities_model.dart';
import 'package:pinkribbonbhc/utils/exceptions/firebase_exceptions.dart';
import 'package:pinkribbonbhc/utils/exceptions/platform_exceptions.dart';

class FacilitiesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Facility>> fetchHealthcareFacilities() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('HealthcareFacilities').get();
      return querySnapshot.docs
          .map((doc) => Facility.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<List<Facility>> fetchHealthcareFacilitiesByRegion(
      String region) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('HealthcareFacilities')
          .where('region', isEqualTo: region)
          .get();
      return querySnapshot.docs
          .map((doc) => Facility.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again. $e';
    }
  }
}
