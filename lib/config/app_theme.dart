import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppTheme {
  /////////////////////////////////////////
  ///////////// Dark Theme ///////////////
  /////////////////////////////////////////
  static final TextStyle darkDefaultTextStyle = TextStyle(
    fontFamily: 'Vazir',
    color: Colors.grey[200],
  );

  static ThemeData darkThemeData = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Colors.grey.shade900,
    errorColor: Colors.redAccent,
    appBarTheme: const AppBarTheme(
      elevation: 4,
    ),
    tabBarTheme: TabBarTheme(
      labelStyle: darkDefaultTextStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: darkDefaultTextStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
        ),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Colors.transparent,
      hintStyle: TextStyle(
        fontFamily: 'Vazir',
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.cyan, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: Colors.cyan,
      // onPrimary: Colors.grey.shade900,
      onPrimary: Colors.white,
      secondary: Colors.deepOrange,
      onSecondary: Colors.white,
      background: Colors.grey.shade900,
      onBackground: Colors.white,
      shadow: Colors.cyan.withOpacity(0.4),
      error: Colors.redAccent,
      onError: Colors.white,
    ),
    textTheme: TextTheme(
      headline1: darkDefaultTextStyle.copyWith(fontSize: 48, fontWeight: FontWeight.bold),
      headline2: darkDefaultTextStyle.copyWith(fontSize: 40, fontWeight: FontWeight.bold),
      headline3: darkDefaultTextStyle.copyWith(fontSize: 36, fontWeight: FontWeight.bold),
      headline4: darkDefaultTextStyle.copyWith(fontSize: 28, fontWeight: FontWeight.bold),
      headline5: darkDefaultTextStyle.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
      headline6: darkDefaultTextStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
      bodyText1: darkDefaultTextStyle.copyWith(fontSize: 16),
      bodyText2: darkDefaultTextStyle.copyWith(fontSize: 14),
      button: darkDefaultTextStyle.copyWith(fontSize: 14),
      caption: darkDefaultTextStyle.copyWith(fontSize: 12, color: Colors.grey.shade500),
      subtitle1: darkDefaultTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
      subtitle2: darkDefaultTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
    ),
  );


  /////////////////////////////////////////
  ///////////// Light Theme ///////////////
  /////////////////////////////////////////
  static final TextStyle lightDefaultTextStyle = TextStyle(
    fontFamily: 'Vazir',
    color: Colors.grey[800],
  );

  static ThemeData lightThemeData = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Colors.white,
    errorColor: Colors.redAccent,
    appBarTheme: const AppBarTheme(
      elevation: 4,
    ),
    tabBarTheme: TabBarTheme(
      labelStyle: lightDefaultTextStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: lightDefaultTextStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
        ),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Colors.transparent,
      hintStyle: TextStyle(
        fontFamily: 'Vazir',
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.cyan, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: Colors.cyan,
      // onPrimary: Colors.grey.shade900,
      onPrimary: Colors.white,
      secondary: Colors.deepOrange,
      onSecondary: Colors.white,
      background: Colors.white,
      onBackground: Colors.grey.shade900,
      shadow: Colors.black.withOpacity(0.1),
      error: Colors.redAccent,
      onError: Colors.white,
    ),
    textTheme: TextTheme(
        headline1: lightDefaultTextStyle.copyWith(fontSize: 48, fontWeight: FontWeight.bold),
        headline2: lightDefaultTextStyle.copyWith(fontSize: 40, fontWeight: FontWeight.bold),
        headline3: lightDefaultTextStyle.copyWith(fontSize: 34, fontWeight: FontWeight.bold),
        headline4: lightDefaultTextStyle.copyWith(fontSize: 28, fontWeight: FontWeight.bold),
        headline5: lightDefaultTextStyle.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
        headline6: lightDefaultTextStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
        bodyText1: lightDefaultTextStyle.copyWith(fontSize: 16),
        bodyText2: lightDefaultTextStyle.copyWith(fontSize: 14),
        button: lightDefaultTextStyle.copyWith(fontSize: 14),
        caption: lightDefaultTextStyle.copyWith(fontSize: 12, color: Colors.grey.shade500),
        subtitle1: lightDefaultTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
        subtitle2: lightDefaultTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold)
    ),
  );
}

extension ColorSchemeExtension on ColorScheme {
  Color get successContainer => Get.isDarkMode ? const Color(0xFF0AAA45) : const Color(0xFFC2FCD7);
  Color get onSuccessContainer => Get.isDarkMode ? const Color(0xFFBCF8D2) : const Color(0xFF038A35);
  Color get warningContainer => Get.isDarkMode ? const Color(0xFFEFB01D) : const Color(0xFFFFE6AB);
  Color get onWarningContainer => Get.isDarkMode ? const Color(0xFFFFEAB8) : const Color(0xFFD49806);
  Color get infoContainer => Get.isDarkMode ? const Color(0xFF0363BC) : const Color(0xFFD6ECFF);
  Color get onInfoContainer => Get.isDarkMode ? const Color(0xFFD6ECFF) : const Color(0xFF045098);
  Color get questionContainer => Get.isDarkMode ? const Color(0xFF8A43FF) : const Color(0xFFEBDFFF);
  Color get onQuestionContainer => Get.isDarkMode ? const Color(0xFFEBDFFF) : const Color(0xFF7323F5);
}
