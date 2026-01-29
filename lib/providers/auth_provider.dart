import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;
  bool _isLoading = false;
  final bool isInitialized;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthProvider({this.isInitialized = true}) {
    if (isInitialized) {
      _checkAuthStatus();
    }
  }

  Future<void> _checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    _authService.authStateChanges.listen((firebaseUser) async {
      if (firebaseUser != null) {
        _user = await _authService.getUserData(firebaseUser.uid);
      } else {
        _user = null;
      }
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<String?> login(String email, String password) async {
    if (!isInitialized) return "Database not connected";
    _isLoading = true;
    notifyListeners();
    try {
      _user = await _authService.signInWithEmailAndPassword(email, password);
      _isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  Future<String?> register(String email, String password, String role) async {
    if (!isInitialized) return "Database not connected";
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.signUpWithEmailAndPassword(email, password, role);

      // Force logout so the user has to login manually
      await _authService.signOut();
      _user = null;

      _isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  Future<void> logout() async {
    if (!isInitialized) return;
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
}
