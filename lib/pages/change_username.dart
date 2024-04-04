import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../components/my_text_field.dart';

class ChangeUserName extends StatefulWidget {
  ChangeUserName({super.key});

  @override
  State<ChangeUserName> createState() => _ChangeUserNameState();
}

class _ChangeUserNameState extends State<ChangeUserName> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _username = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FocusNode myFocusNode = FocusNode();

  User? getCurrentuser() {
    return _auth.currentUser;
  }

  // Function to update the username in Firestore
  Future<void> updateUsernameFirestore(String newUsername) async {
    User? user = getCurrentuser();
    if (user != null) {
      await _firestore.collection('Users').doc(user.uid).update({
        'username': newUsername,
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
      return {'username': 'Username not available'};
    }
  }

  final ScrollController _scrollController = ScrollController();

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void initState() {
    super.initState();

    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
      }
    });

    Future.delayed(const Duration(microseconds: 500), () => scrollDown());
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  // Function to update the username in Firebase Authentication
  Future<void> updateUsernameFirebaseAuth(String newUsername) async {
    User? user = getCurrentuser();
    if (user != null) {
      await user.updateDisplayName(newUsername);
    }
  }

  // Function to handle the username change
  Future<void> handleUsernameChange(String newUsername) async {
    try {
      await updateUsernameFirestore(newUsername);
      await updateUsernameFirebaseAuth(newUsername);

      // Show a success message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Username updated successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating username. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserData(),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          String username =
              snapshot.data?['username'] ?? 'Username not available';
          _username.text = username;
          return Scaffold(
            appBar: AppBar(
              title: Text('$username'),
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: Colors.grey,
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                MyTextField(
                  hintText: 'Change Your Username',
                  obscureText: false,
                  controller: _username,
                  focusNode: myFocusNode,
                ),
                IconButton(
                  onPressed: () {
                    String newUserName = _username.text.trim();
                    if (newUserName.isNotEmpty) {
                      handleUsernameChange(newUserName);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Username cannot be empty.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.check),
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
