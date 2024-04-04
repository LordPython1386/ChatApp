import 'package:chatapp/theme/dark_mode.dart';
import 'package:chatapp/theme/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ThemeProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? getcurrentUSer() {
    return _auth.currentUser;
  }

  Future<Map<String, dynamic>> getData() async {
    User? user = getcurrentUSer();

    DocumentSnapshot userDoc =
        await _firestore.collection('Users').doc(user!.uid).get();

    if (userDoc['isDarkMode'] == true) {
      _themeData = darkMode;
      return userDoc.data() as Map<String, dynamic>;
    } else {
      _themeData = lightMode;
      return {'email': ''};
    }
  }

  Future<void> checkTheme() async {
    User? user = getcurrentUSer();

    DocumentSnapshot userDoc =
        await _firestore.collection('Users').doc(user!.uid).get();

    if (userDoc.exists) {
      bool isDarkMode = userDoc['isDarkMode'] ?? false;

      if (isDarkMode) {
        _themeData = darkMode;
      } else {
        _themeData = lightMode;
      }

      notifyListeners();
    }
  }

  Future<void> updateFireStore(bool isdarMode) async {
    User? user = getcurrentUSer();
    if (user != null) {
      await _firestore.collection('Users').doc(user!.uid).update({
        'isDarkMode': isdarMode,
      });
      return user.updateDisplayName(isDarkMode.toString());
    }
  }

  Future<void> handle(bool isDarkModeToggle) async {
    await updateFireStore(isDarkModeToggle);
  }

  ThemeData _themeData = lightMode;
  ThemeData get themeData => _themeData;
  bool get isDarkMode => _themeData == darkMode;
  set themeData(ThemeData themeData) {
    checkTheme();
    // _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      // themeData = darkMode;
      checkTheme();
      handle(true);
    } else {
      // themeData = lightMode;
      checkTheme();
      handle(false);
    }
  }
}
