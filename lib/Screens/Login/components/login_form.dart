import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../Chat/chat_screen.dart';
import '../../../Services/auth_service.dart'; // Assuming you have an AuthenticationService class

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthenticationService();

  void _handleLogin() async {
    //this navigator is for debugging purposes ***1
    /*
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const ChatScreen();
        },
      ),
    );
    */
    //here ends the debug code  ***1

    final email = _emailController.text;
    final password = _passwordController.text;

    final isAuthenticated = await _authService.signIn(email, password);

    if (isAuthenticated) {
      // Navigate to the desired screen (e.g., ChatScreen)
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const ChatScreen();
          },
        ),
        ModalRoute.withName("/chat"),
      );
    } else {
      // Show an error message
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Invalid email or password'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            decoration: const InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: _passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _handleLogin,
            child: Text(
              "Login".toUpperCase(),
            ),
          ),
          const SizedBox(height: defaultPadding),
        ],
      ),
    );
  }
}
