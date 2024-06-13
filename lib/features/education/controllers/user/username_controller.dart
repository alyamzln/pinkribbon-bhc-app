import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pinkribbonbhc/utils/popups/loaders.dart';

class UserNameController extends GetxController {
  var firstName = ''.obs;
  var lastName = ''.obs;
  var email = ''.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    fetchFirstName();
  }

  void fetchFirstName() async {
    try {
      String userId =
          this.userId; // Use the getter method to retrieve the userId
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        firstName.value = userDoc['FirstName'];
        lastName.value = userDoc['LastName'];
        email.value = userDoc['Email'];
      }
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Error!', message: 'Error fetching user data!');
      throw Exception('Error fetching user data: $e');
    }
  }

  String get userId {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        return user.uid;
      } else {
        throw Exception('User is not logged in.');
      }
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Error!', message: 'Error getting user ID!');
      throw Exception('Error getting user ID: $e');
    }
  }
}
