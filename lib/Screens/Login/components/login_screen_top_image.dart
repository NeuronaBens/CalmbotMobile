import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class LoginScreenTopImage extends StatelessWidget {
  const LoginScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 24,
              child: Image.asset("assets/images/playful1.png"), // Changed to use a PNG image
            ),
            const Spacer(),
          ],
        ),
        //const SizedBox(height: defaultPadding),
      ],
    );
  }
}
