import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:e_voting/services/firebase_auth_service.dart';

class FirebaseAuthProvider with ChangeNotifier {
  final _authservices = FirebaseAuthService();

  bool _isLoading = false;
  bool _hasError = false;
  String _errorMsg = '';

  bool get isLoading => _isLoading;
  set(bool isload) {
    _isLoading = isload;
  }

  bool get hasError => _hasError;
  String get errorMsg => _errorMsg;

  Future<void> signInwithEmailandPassword(String email, String password) async {
    _isLoading = true;

    try {
      await _authservices.signIn(email, password);
    } on WrongPasswordException catch (e) {
      _errorMsg = e.message;
      _hasError = true;
    } on UserNotFoundException catch (e) {
      _errorMsg = e.message;
      _hasError = true;
    } on UnkownException {
      _errorMsg = 'Something went wrong';
      _hasError = true;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signupwithEmailandPassword(String email, String password) async {
    _isLoading = true;

    try {
      await _authservices.signupWithEmailAndPassword(
        email,
        password,
      );
    } on EmailAlreadyInUse catch (e) {
      _errorMsg = e.message;
      _hasError = true;
    } on PasswordLengthException catch (e) {
      _errorMsg = e.message;
      _hasError = true;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    try {
      await _authservices.signOut();
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }
}
