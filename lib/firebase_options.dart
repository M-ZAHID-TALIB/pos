// File generated/created by Antigravity assistant.
// Manually add your keys here OR run 'flutterfire configure' to overwrite this file.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyDUQw8uQt9Yyd0A4kcNITQNGOtAy518aW0',
    appId: '1:461307480412:web:bea8f6651e638f3527d999',
    messagingSenderId: '461307480412',
    projectId: 'pos-c4d2f',
    authDomain: 'pos-c4d2f.firebaseapp.com',
    storageBucket: 'pos-c4d2f.firebasestorage.app',
    measurementId: 'G-KE50PFTGPJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDrupjDF_icQZmgpWEaGY9kbbw0HQ4udNs',
    appId: '1:461307480412:android:a2779f682628dcc427d999',
    messagingSenderId: '461307480412',
    projectId: 'pos-c4d2f',
    storageBucket: 'pos-c4d2f.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'PASTE_YOUR_IOS_API_KEY_HERE',
    appId: 'PASTE_YOUR_IOS_APP_ID_HERE',
    messagingSenderId: 'PASTE_YOUR_SENDER_ID_HERE',
    projectId: 'PASTE_YOUR_PROJECT_ID_HERE',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
    iosBundleId: 'com.example.pos',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'PASTE_YOUR_MACOS_API_KEY_HERE',
    appId: 'PASTE_YOUR_MACOS_APP_ID_HERE',
    messagingSenderId: 'PASTE_YOUR_SENDER_ID_HERE',
    projectId: 'PASTE_YOUR_PROJECT_ID_HERE',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
    iosBundleId: 'com.example.pos',
  );
}
