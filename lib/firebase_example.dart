import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Small examples showing common Firebase calls. Use them from your app
/// after Firebase is initialized (main.dart initializes Firebase).

class FirebaseExample {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> signInAnonymously() async {
    return await _auth.signInAnonymously();
  }

  Future<DocumentReference> addOrder(Map<String, dynamic> data) async {
    return await _firestore.collection('orders').add(data);
  }

  Stream<QuerySnapshot> ordersStream() {
    return _firestore.collection('orders').snapshots();
  }
}
