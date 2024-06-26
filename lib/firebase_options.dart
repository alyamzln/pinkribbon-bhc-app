// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCE69nJSqzXN6jJUC6dWaSMaUMGfjQ_oRE',
    appId: '1:164700029901:web:aac1bbf776d7b11f3b7a84',
    messagingSenderId: '164700029901',
    projectId: 'pinkribbonbhc-55787',
    authDomain: 'pinkribbonbhc-55787.firebaseapp.com',
    storageBucket: 'pinkribbonbhc-55787.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDCRAg55prSyBl0eXihhWTVyQAX2ilQSeU',
    appId: '1:164700029901:android:310b8ee3874c87ec3b7a84',
    messagingSenderId: '164700029901',
    projectId: 'pinkribbonbhc-55787',
    storageBucket: 'pinkribbonbhc-55787.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDpw0rGphD0_Iwep3E5gGoEfYCu3SKrLuA',
    appId: '1:164700029901:ios:1f258ab157977f143b7a84',
    messagingSenderId: '164700029901',
    projectId: 'pinkribbonbhc-55787',
    storageBucket: 'pinkribbonbhc-55787.appspot.com',
    androidClientId: '164700029901-ubbo7ad83rd87kt65rfiommdh3utnb4p.apps.googleusercontent.com',
    iosClientId: '164700029901-hg6ietdnc7jl71h3o5u0sioqa1gc4siq.apps.googleusercontent.com',
    iosBundleId: 'com.example.pinkribbonbhc',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDpw0rGphD0_Iwep3E5gGoEfYCu3SKrLuA',
    appId: '1:164700029901:ios:b7bfb9cd004b0dd73b7a84',
    messagingSenderId: '164700029901',
    projectId: 'pinkribbonbhc-55787',
    storageBucket: 'pinkribbonbhc-55787.appspot.com',
    androidClientId: '164700029901-ubbo7ad83rd87kt65rfiommdh3utnb4p.apps.googleusercontent.com',
    iosClientId: '164700029901-q317er1fm2m76p4c7tvmumcfkjhq7jep.apps.googleusercontent.com',
    iosBundleId: 'com.example.pinkribbonbhc.RunnerTests',
  );
}
