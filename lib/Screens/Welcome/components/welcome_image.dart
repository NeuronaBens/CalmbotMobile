import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: "Bienvenido a ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  color: Colors
                      .black, // Set the color for the first part of the text
                ),
              ),
              TextSpan(
                text: "Calmy",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  color: Color(0xFF7A72DE), // Set the color for "Calmy"
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: defaultPadding),
        const Text(
          "Tu chatbot basado en inteligencia artificial para el manejo del estrés y la ansiedad",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey, // Adjust color as needed
            fontSize: 18,
          ),
        ),
        const SizedBox(height: defaultPadding * 2),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: SvgPicture.asset(
                "assets/icons/logo.svg",
                width: MediaQuery.of(context).size.width *
                    0.4, // Adjust the percentage as needed
                height: MediaQuery.of(context).size.width *
                    0.4, // Adjust the percentage as needed
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: defaultPadding * 4),
      ],
    );
  }
}
