import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          const SizedBox(height: defaultPadding),
          const Text(
            "Cree una cuenta en nuestro sitio web.",
            style: TextStyle(
              color: Colors.grey, // Choose a suitable color for the message
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: defaultPadding / 2),
          ElevatedButton(
            // here we define where login takes/do
            onPressed: () {
              //TODO
              //this should be replaced with the actual URL
              Uri url = Uri.parse("https://www.example.com");
              launchUrl(url);
            },
            child: Text("Sign Up".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
