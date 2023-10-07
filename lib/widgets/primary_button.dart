import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/constants.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    this.maximumSize = const Size(double.infinity, 52),
    required this.text,
    this.fontSize = 14,
    required this.onPressed,
    this.minimumSize = const Size(double.infinity, 52),
    this.borderRadiusSize = 4,
    this.bgColor = primaryColor,
    this.textColor = blackColor,
    this.fontWeigh = FontWeight.w700,
  }) : super(key: key);

  final VoidCallback onPressed;

  // final List<Color> gradiantColor;
  final String text;
  final Size maximumSize;
  final Size minimumSize;
  final double fontSize;
  final double borderRadiusSize;
  final Color bgColor;
  final Color textColor;
  final FontWeight fontWeigh;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(borderRadiusSize);
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        // gradient: LinearGradient(
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        //   // colors: gradiantColor,
        // ),
        borderRadius: borderRadius,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0.0),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            foregroundColor: MaterialStateProperty.all(Colors.transparent),
            splashFactory: NoSplash.splashFactory,
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: borderRadius)),
            minimumSize: MaterialStateProperty.all(minimumSize),
            maximumSize: MaterialStateProperty.all(maximumSize),
            backgroundColor: MaterialStateProperty.all(bgColor)),
        child: Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Text(
            text,
            style: GoogleFonts.roboto(
              color: textColor,
              fontSize: 18.0,
              fontWeight: fontWeigh,
            ),
          ),
        ),
      ),
    );
  }
}
