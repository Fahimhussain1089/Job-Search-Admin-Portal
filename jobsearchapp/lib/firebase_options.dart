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
    apiKey: '',//connect your firebase APIkey
    appId: '1:89813258371:web:bc54b960c55cb7debf0bb6',
    messagingSenderId: '89813258371',
    projectId: 'jobsearchapp-b29b6',
    authDomain: 'jobsearchapp-b29b6.firebaseapp.com',
    storageBucket: 'jobsearchapp-b29b6.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: '',//connect your firebase APIkey
    appId: '1:89813258371:android:c6fc55d899524af0bf0bb6',
    messagingSenderId: '89813258371',
    projectId: 'jobsearchapp-b29b6',
    storageBucket: 'jobsearchapp-b29b6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: '',//connect your firebase APIkey
    appId: '1:89813258371:ios:9b7f360dc88d9f3abf0bb6',
    messagingSenderId: '89813258371',
    projectId: 'jobsearchapp-b29b6',
    storageBucket: 'jobsearchapp-b29b6.appspot.com',
    iosBundleId: 'com.example.jobsearchapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: '',//connect your firebase APIkey
    appId: '1:89813258371:ios:963b15477f6c7229bf0bb6',
    messagingSenderId: '89813258371',
    projectId: 'jobsearchapp-b29b6',
    storageBucket: 'jobsearchapp-b29b6.appspot.com',
    iosBundleId: 'com.example.jobsearchapp.RunnerTests',
  );
}
