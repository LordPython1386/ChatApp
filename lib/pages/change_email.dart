import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../components/my_text_field.dart';

class ChangeEmail extends StatefulWidget {
  ChangeEmail({super.key});

  @override
  State<ChangeEmail> createState() => _ChangeemailState();
}

class _ChangeemailState extends State<ChangeEmail> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _email = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FocusNode myFocusNode = FocusNode();

  User? getCurrentuser() {
    return _auth.currentUser;
  }

  // Function to update the username in Firestore
  Future<void> updateEmailFirestore(String newEmail) async {
    User? user = getCurrentuser();
    if (user != null) {
      await _firestore.collection('Users').doc(user.uid).update({
        'email': newEmail,
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
      return {'email': 'email not available'};
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
  Future<void> updateEmailFirebaseAuth(String newEmail) async {
    User? user = getCurrentuser();
    if (user != null) {
      await user.updateEmail(newEmail);
    }
  }

  // Function to handle the username change
  Future<void> handleEmailChange(String newEmail) async {
    try {
      await updateEmailFirestore(newEmail);
      await updateEmailFirebaseAuth(newEmail);

      // Show a success message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email updated successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating email. Please try again.'),
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
          String email = snapshot.data?['email'] ?? 'Email not available';
          _email.text = email;
          return Scaffold(
            appBar: AppBar(
              title: Text('$email'),
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
                  hintText: 'Change Your Email',
                  obscureText: false,
                  controller: _email,
                  focusNode: myFocusNode,
                ),
                IconButton(
                  onPressed: () {
                    String newEmail = _email.text.trim();
                    if (newEmail.isNotEmpty) {
                      handleEmailChange(newEmail);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Email cannot be empty.'),
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
