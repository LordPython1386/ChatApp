import 'package:chatapp/theme/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatapp/Services/auth/auth_service.dart';

class settingsPage extends StatelessWidget {
  settingsPage({super.key});
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool darkMode = false;
  User? getCurrentuser() {
    return _auth.currentUser;
  }

  Future<void> getSettings(bool isDarkMode) async {
    User? user = getCurrentuser();
    if (user != null) {
      await _firestore.collection('Users').doc(user.uid).update({
        'isDarkMode': isDarkMode,
      });
    }
  }

  Future<Map<String, dynamic>> getUserData() async {
    User? user = getCurrentuser();

    DocumentSnapshot userDoc =
        await _firestore.collection('Users').doc(user?.uid).get();
    if (userDoc.exists) {
      return userDoc.data() as Map<String, dynamic>;
    } else {
      return {'email': 'Unkown Error Try again Later'};
    }
  }

  Future<void> updateSettingsIsDarkMode(bool isDarkMode) async {
    User? user = getCurrentuser();

    if (user != null) {
      await user.updateDisplayName(isDarkMode.toString());
    }
  }

  Future<void> updateSettingFirebaseAuth(bool isDarkMode) async {
    User? user = getCurrentuser();
    if (user != null) {
      await user.updateDisplayName(isDarkMode.toString());
    }
  }

  Future<void> handleSettings(bool isdarkMode) async {
    await updateSettingFirebaseAuth(isdarkMode);
    await updateSettingsIsDarkMode(isdarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("S E T T I N G S"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey,
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(25),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Dark Mode"),
            CupertinoSwitch(
              value:
                  Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
              onChanged: (value) =>
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme(),
            )
          ],
        ),
      ),
    );
  }
}
