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
    apiKey: 'AIzaSyBiGKxSZvmsBm9B3t8PonbHtLj62jWrd2U',
    appId: '1:58959430568:web:871552346728d620ced39d',
    messagingSenderId: '58959430568',
    projectId: 'retirement-management-system',
    authDomain: 'retirement-management-system.firebaseapp.com',
    databaseURL: 'https://retirement-management-system-default-rtdb.firebaseio.com',
    storageBucket: 'retirement-management-system.appspot.com',
    measurementId: 'G-WZ0QDQTN5S',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCpkwAFui0PciVorZ9zOpENs3i-mVsLGK4',
    appId: '1:58959430568:android:c1e32699446731b1ced39d',
    messagingSenderId: '58959430568',
    projectId: 'retirement-management-system',
    databaseURL: 'https://retirement-management-system-default-rtdb.firebaseio.com',
    storageBucket: 'retirement-management-system.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA8ORqs0bNVYSAsA53AzYgBucX-sKXT_SA',
    appId: '1:58959430568:ios:250efbf69d461bccced39d',
    messagingSenderId: '58959430568',
    projectId: 'retirement-management-system',
    databaseURL: 'https://retirement-management-system-default-rtdb.firebaseio.com',
    storageBucket: 'retirement-management-system.appspot.com',
    iosClientId: '58959430568-7unnh237cls9qs3strhgdlvoo6ajhkqe.apps.googleusercontent.com',
    iosBundleId: 'com.example.retirementManagementSystem',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA8ORqs0bNVYSAsA53AzYgBucX-sKXT_SA',
    appId: '1:58959430568:ios:2f41ad51a86fdfd1ced39d',
    messagingSenderId: '58959430568',
    projectId: 'retirement-management-system',
    databaseURL: 'https://retirement-management-system-default-rtdb.firebaseio.com',
    storageBucket: 'retirement-management-system.appspot.com',
    iosClientId: '58959430568-5m5ubc7feerqjnkjruk0ejlboh6pqnd4.apps.googleusercontent.com',
    iosBundleId: 'com.example.retirementManagementSystem.RunnerTests',
  );
}
