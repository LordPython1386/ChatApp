import 'package:flutter/material.dart';
import 'package:chatapp/Services/auth/auth_service.dart';
import 'package:chatapp/chats/chat_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'change_email.dart';
import 'change_username.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({
    super.key,
  });

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<Map<String, dynamic>> getUserData() async {
    User? user = getCurrentUser();
    DocumentSnapshot userDoc =
        await _firestore.collection('Users').doc(user?.uid).get();

    if (userDoc.exists) {
      return userDoc.data() as Map<String, dynamic>;
    } else {
      return {
        'email': 'Email not available',
        'username': 'Username not available'
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserData(),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          String userEmail = snapshot.data?['email'] ?? 'Email not available';
          String username =
              snapshot.data?['username'] ?? 'Username not available';

          return Scaffold(
            appBar: AppBar(
              title: const Text("P R O F I L E"),
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: Colors.grey,
            ),
            body: Column(
              children: [
                SizedBox(height: 20),
                Center(
                  child: Icon(
                    Icons.account_circle_rounded,
                    size: 120,
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$username', // Display the username here
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangeUserName()),
                        );
                      },
                      icon: Icon(Icons.edit),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$userEmail', // Display the email here
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeEmail(),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
