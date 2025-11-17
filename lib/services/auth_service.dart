import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign-in with email and password
  Future<UserModel?> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      // Sign in the user with Firebase Auth
      final UserCredential userCredential = await _auth.signInWithEmailPassword(
        email: email,
        password: password,
      );

      // Get the user's UID
      final uid = userCredential.user!.uid;

      // Fetch user data from Firestore
      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      final userData = userDoc.data() as Map<String, dynamic>;

      return UserModel.fromMap(userData);
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error signing in: ${e.code}");
      // Rethrow FirebaseAuthException to be handled in the UI
      rethrow;
    } catch (e) {
      print("Error signing in: $e");
      // Rethrow other exceptions
      rethrow;
    }
  }

  // Sign-up with email and password
  Future<UserModel?> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      // Create a new user with Firebase Auth
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Get the user's UID
      final uid = userCredential.user!.uid;

      // Store user data in Firestore
      await _firestore.collection('users').doc(uid).set({
        'email': email,
        'role': 'staff', // Assign a default role
      });

      // Fetch the created user document and return a UserModel
      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      final userData = userDoc.data() as Map<String, dynamic>;

      return UserModel.fromMap(userData);
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error signing up: ${e.code}");
      // Rethrow FirebaseAuthException to be handled in the UI
      rethrow;
    } catch (e) {
      print("Error signing up: $e");
      // Rethrow other exceptions
      rethrow;
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      if (e is FirebaseAuthException) {
        print("Firebase Auth Error sending password reset email: ${e.code}");
        rethrow; // Rethrow FirebaseAuthException
      }
      print("Error sending password reset email: $e");
    }
  }

  // Check if the user is signed in
  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  // Sign out the user
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

extension on FirebaseAuth {
  signInWithEmailPassword({required String email, required String password}) {}
}
