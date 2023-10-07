import 'package:flutter/material.dart';
import 'package:seller_app/utils/constants.dart';

class MyCustomTheme {
  static final borderRadius = BorderRadius.circular(4.0);
  static final theme = ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarTextStyle: TextStyle(color: blackColor),
        iconTheme: IconThemeData(color: blackColor),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        hintStyle: const TextStyle(color: grayColor),
        labelStyle: const TextStyle(color: grayColor, fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(color: borderColor),
        ),
        fillColor: filledColor,
        filled: true,
        focusColor: blackColor,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        // selectedLabelStyle: TextStyle(color: primaryColor),
        elevation: 3,
        backgroundColor: Color(0x00ffffff),
        selectedLabelStyle:
        TextStyle(color: blackColor, fontSize: 14.0),
        unselectedLabelStyle: TextStyle(color: grayColor, fontSize: 12.0),
        selectedItemColor: blackColor,
        unselectedItemColor: grayColor,
        showUnselectedLabels: true,

      ),

      // switchTheme: SwitchThemeData(
      //   thumbColor: MaterialStateProperty.all(primaryColor),
      // )
      //   textSelectionTheme: const TextSelectionThemeData(
      //     cursorColor: blackColor,
      //     selectionColor: blackColor,
      //     selectionHandleColor: blackColor,
      // )
      );
}
