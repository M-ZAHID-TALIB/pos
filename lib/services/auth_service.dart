import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/user_model.dart';

class AuthService {
  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  // Sign-in with email and password
  Future<UserModel?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user!.uid;
      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        throw Exception("User data not found in database.");
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      // Ensure uid is included in the map if it's not stored in the document fields
      userData['uid'] = uid;

      return UserModel.fromMap(userData);
    } catch (e) {
      rethrow;
    }
  }

  // Sign-up with email and password
  Future<UserModel?> signUpWithEmailAndPassword(
    String email,
    String password,
    String role,
  ) async {
    UserCredential? userCredential;
    try {
      // 1. Create Auth User
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      // 2. Prepare Data
      Map<String, dynamic> userData = {
        'uid': uid, // Redundant but good for exporting
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      };

      // 3. Save to Firestore
      // Using set() with merge:true is safer generally, though new doc doesn't strictly need it.
      await _firestore.collection('users').doc(uid).set(userData);

      return UserModel.fromMap(userData);
    } catch (e) {
      // If Firestore save fails, we should ideally delete the Auth user
      // so the user can try registering again.
      if (userCredential?.user != null) {
        try {
          await userCredential!.user!.delete();
        } catch (_) {
          // Ignore deletion error
        }
      }
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserModel?> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      data['uid'] = uid;
      return UserModel.fromMap(data);
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
