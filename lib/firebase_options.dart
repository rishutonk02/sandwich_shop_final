// Generated Firebase options for Sandwich Shop project.
// Values extracted from Firebase project `sandwich-shop-20251219-01`.
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAcqFOvijce9-gWAtMlbGQjaW1tZ9s5t4s',
    appId: '1:1014531174278:android:36e86ab6c058f39417c607',
    messagingSenderId: '1014531174278',
    projectId: 'sandwich-shop-20251219-01',
    storageBucket: 'sandwich-shop-20251219-01.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBKWd1Hk4ebkIm6MEi0VUr8xq6tVkv26Tc',
    appId: '1:1014531174278:ios:541a31ee6c33751b17c607',
    messagingSenderId: '1014531174278',
    projectId: 'sandwich-shop-20251219-01',
    storageBucket: 'sandwich-shop-20251219-01.firebasestorage.app',
    iosClientId: '1014531174278-REPLACE.apps.googleusercontent.com',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC_UL3yEqf7epsNXjMekoozRbwoKKDC6JM',
    appId: '1:1014531174278:web:b0e6b003d0e692c217c607',
    messagingSenderId: '1014531174278',
    projectId: 'sandwich-shop-20251219-01',
    authDomain: 'sandwich-shop-20251219-01.firebaseapp.com',
    storageBucket: 'sandwich-shop-20251219-01.firebasestorage.app',
  );
}
