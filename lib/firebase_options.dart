// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyAeQMNC6Yo4231XrsXl3I4I4g-ayenGHvE',
    appId: '1:997638058017:web:bfddf822faff46622b7360',
    messagingSenderId: '997638058017',
    projectId: 'ta-bultang',
    authDomain: 'ta-bultang.firebaseapp.com',
    storageBucket: 'ta-bultang.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCkEBR_CFbroxiW4slFOWAdmjO8ZR6ZScM',
    appId: '1:997638058017:android:bffa195a7eb57d922b7360',
    messagingSenderId: '997638058017',
    projectId: 'ta-bultang',
    storageBucket: 'ta-bultang.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAizgNMSy-mPjTpAci27SUhg7uyKjjjBRU',
    appId: '1:997638058017:ios:3e9fc0b0b58cd3102b7360',
    messagingSenderId: '997638058017',
    projectId: 'ta-bultang',
    storageBucket: 'ta-bultang.firebasestorage.app',
    iosBundleId: 'com.example.taBultang',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAizgNMSy-mPjTpAci27SUhg7uyKjjjBRU',
    appId: '1:997638058017:ios:3e9fc0b0b58cd3102b7360',
    messagingSenderId: '997638058017',
    projectId: 'ta-bultang',
    storageBucket: 'ta-bultang.firebasestorage.app',
    iosBundleId: 'com.example.taBultang',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAeQMNC6Yo4231XrsXl3I4I4g-ayenGHvE',
    appId: '1:997638058017:web:b74523767b15255b2b7360',
    messagingSenderId: '997638058017',
    projectId: 'ta-bultang',
    authDomain: 'ta-bultang.firebaseapp.com',
    storageBucket: 'ta-bultang.firebasestorage.app',
  );
}
