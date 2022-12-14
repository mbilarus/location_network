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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyB2V04s2A-WZpyW_6FeIj_gtQ8pvCSz5kk',
    appId: '1:464405313832:web:46280e2e320a982e91f81d',
    messagingSenderId: '464405313832',
    projectId: 'locnet-23c64',
    authDomain: 'locnet-23c64.firebaseapp.com',
    storageBucket: 'locnet-23c64.appspot.com',
    measurementId: 'G-XLYRBY0HF4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAiwurJVH3SQ2_rLWyq0igVJOzbzhYvgvA',
    appId: '1:464405313832:android:846022e92cc7585f91f81d',
    messagingSenderId: '464405313832',
    projectId: 'locnet-23c64',
    storageBucket: 'locnet-23c64.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDPukT18pUowDeE-2Aw7CWxgatqbvRrIgA',
    appId: '1:464405313832:ios:48d32275e5ac904091f81d',
    messagingSenderId: '464405313832',
    projectId: 'locnet-23c64',
    storageBucket: 'locnet-23c64.appspot.com',
    androidClientId: '464405313832-t4t9294gar70idvsf67orenn546j6m4s.apps.googleusercontent.com',
    iosClientId: '464405313832-k3cbsph9f4tulrc4dona6ikr0hb3t1ie.apps.googleusercontent.com',
    iosBundleId: 'com.mbilarus.ln',
  );
}
