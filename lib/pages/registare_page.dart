import 'package:flutter/material.dart';
import 'package:chatapp/Services/auth/auth_service.dart';
import '../components/my_button.dart';
import '../components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //email controller and password controller
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _pwController = TextEditingController();

  final TextEditingController _ConfrimpwController = TextEditingController();

  final TextEditingController _Username = TextEditingController();

  final bool _isDarkMode = false;

  FocusNode myFocusNode = FocusNode();

  void Register(BuildContext context) {
    // get auth service
    final _auth = AuthService();
    if (_pwController.text == _ConfrimpwController.text ||
        _Username.text.length >= 4 ||
        _pwController.text.length >= 6) {
      try {
        _auth.signUpWithEmailPassword(
          _emailController.text,
          _pwController.text,
          _Username.text,
          _isDarkMode,
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }
    if (_Username.text.length < 4) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("User Name Length most Be more then 4"),
        ),
      );
    }
    if (_pwController.text.length < 6) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Password Length most Be more then 6"),
        ),
      );
    }
    if (_pwController.text != _ConfrimpwController.text) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Passwords Doesn't Match!"),
        ),
      );
    }
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

  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.message,
                size: 60, color: Theme.of(context).colorScheme.primary),
            //Welcome Back
            const SizedBox(
              height: 50,
            ),
            Text(
              "Lets Create An Account For You",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            //Text Field
            MyTextField(
              hintText: "Email",
              obscureText: false,
              controller: _emailController,
              focusNode: myFocusNode,
            ),
            SizedBox(
              height: 10,
            ),
            MyTextField(
              hintText: "User Name",
              obscureText: false,
              controller: _Username,
              focusNode: myFocusNode,
            ),
            SizedBox(
              height: 10,
            ),
            MyTextField(
              hintText: "Password",
              obscureText: true,
              controller: _pwController,
              focusNode: myFocusNode,
            ),
            SizedBox(
              height: 10,
            ),
            MyTextField(
              hintText: "Confirm Password",
              obscureText: true,
              controller: _ConfrimpwController,
              focusNode: myFocusNode,
            ),
            SizedBox(
              height: 25,
            ),
            //Button
            MyButton(
              text: "Register",
              onTap: () => Register(context),
            ),
            const SizedBox(
              height: 25,
            ),
            //Register
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already Have an Account?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    "Login now!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
