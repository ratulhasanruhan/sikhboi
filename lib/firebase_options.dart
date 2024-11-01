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
    apiKey: 'AIzaSyCZyaa7FUDqP1ZEWJqz_cp3Nj0jNuRa1rc',
    appId: '1:224257014426:web:935fe29cda8bf1d3f8bd23',
    messagingSenderId: '224257014426',
    projectId: 'sikhboi-2ef32',
    authDomain: 'sikhboi-2ef32.firebaseapp.com',
    storageBucket: 'sikhboi-2ef32.appspot.com',
    measurementId: 'G-K0BHLCHQ2B',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC5m9sj9l_3bU6w8Sbwo3THYAYS-8g7mSw',
    appId: '1:224257014426:android:ae1ff1e00f5f82b6f8bd23',
    messagingSenderId: '224257014426',
    projectId: 'sikhboi-2ef32',
    storageBucket: 'sikhboi-2ef32.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDXEh9R6X5OjSAMcErhneLuB0UO4IUqXFM',
    appId: '1:224257014426:ios:2bdde58e03e3ef79f8bd23',
    messagingSenderId: '224257014426',
    projectId: 'sikhboi-2ef32',
    storageBucket: 'sikhboi-2ef32.appspot.com',
    iosClientId: '224257014426-ov10mlrheq9gr0o7p3u1fl4jkuo2m4uv.apps.googleusercontent.com',
    iosBundleId: 'com.example.sikhboi',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDXEh9R6X5OjSAMcErhneLuB0UO4IUqXFM',
    appId: '1:224257014426:ios:2bdde58e03e3ef79f8bd23',
    messagingSenderId: '224257014426',
    projectId: 'sikhboi-2ef32',
    storageBucket: 'sikhboi-2ef32.appspot.com',
    iosClientId: '224257014426-ov10mlrheq9gr0o7p3u1fl4jkuo2m4uv.apps.googleusercontent.com',
    iosBundleId: 'com.example.sikhboi',
  );
}
