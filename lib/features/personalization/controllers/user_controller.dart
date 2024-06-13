import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:pinkribbonbhc/data/repositories/user/user_repository.dart';
import 'package:pinkribbonbhc/features/personalization/models/user_model.dart';
import 'package:pinkribbonbhc/utils/popups/loaders.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final userRepository = Get.put(UserRepository());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Save user record from any registration provider
  Future<void> saveUserRecord(UserCredential? userCredentials) async {
    try {
      if (userCredentials != null) {
        final nameParts =
            UserModel.nameParts(userCredentials.user!.displayName ?? '');
        final username =
            UserModel.generateUsername(userCredentials.user!.displayName ?? '');

        // Map data
        final user = UserModel(
            id: userCredentials.user!.uid,
            firstName: nameParts[0],
            lastName:
                nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
            username: username,
            email: userCredentials.user!.email ?? '',
            phoneNumber: userCredentials.user!.phoneNumber ?? '',
            profilePicture: userCredentials.user!.photoURL ?? '');

        // Save user data
        await userRepository.saveUserRecord(user);
      }
    } catch (e) {
      TLoaders.warningSnackBar(
          title: 'Data not saved',
          message:
              'Something went wrong while saving your information. You can re-save your data in your profile.');
    }
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String username,
    File? profilePicture,
  }) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('User is not logged in.');
      }

      String? profilePictureUrl;
      if (profilePicture != null) {
        profilePictureUrl =
            await _uploadProfilePicture(user.uid, profilePicture);
      }

      await _firestore.collection('Users').doc(user.uid).update({
        'FirstName': firstName,
        'LastName': lastName,
        'Email': email,
        'PhoneNumber': phoneNumber,
        'Username': username,
        if (profilePictureUrl != null) 'ProfilePicture': profilePictureUrl,
      });

      TLoaders.successSnackBar(
          title: 'Success!', message: 'Profile updated successfully!');
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Error!', message: 'Failed to update profile: $e');
    }
  }

  Future<String> _uploadProfilePicture(String userId, File file) async {
    try {
      final ref = _storage.ref().child('profile_pictures').child('$userId.jpg');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload profile picture: $e');
    }
  }

  Future<Map<String, dynamic>?> fetchUserData() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('User is not logged in.');
      }

      final DocumentSnapshot userDoc =
          await _firestore.collection('Users').doc(user.uid).get();

      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Error!', message: 'Failed to fetch user data: $e');
      return null;
    }
  }
}
