import 'package:flutter/material.dart';

class AppTheme {

  ///////// text theme /////////
  static TextTheme lightTextTheme = TextTheme();

  static TextTheme darkTextTheme = TextTheme();
  //////////////////////////////


  ///////// ThemeData //////////
  // i use https://m3.material.io/theme-builder#/custom for generate material 3 colors
  static ThemeData lightThemeData = ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF006874),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFF98F0FF),
      onPrimaryContainer: Color(0xFF001F24),
      secondary: Color(0xFFAC3509),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFFFDBD0),
      onSecondaryContainer: Color(0xFF3A0A00),
      tertiary: Color(0xFF006874),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFF97F0FF),
      onTertiaryContainer: Color(0xFF001F24),
      error: Color(0xFFBA1A1A),
      errorContainer: Color(0xFFFFDAD6),
      onError: Color(0xFFFFFFFF),
      onErrorContainer: Color(0xFF410002),
      background: Color(0xFFFBFCFD),
      onBackground: Color(0xFF191C1D),
      surface: Color(0xFFFBFCFD),
      onSurface: Color(0xFF191C1D),
      surfaceVariant: Color(0xFFDBE4E6),
      onSurfaceVariant: Color(0xFF3F484A),
      outline: Color(0xFF6F797B),
      onInverseSurface: Color(0xFFEFF1F1),
      inverseSurface: Color(0xFF2E3132),
      inversePrimary: Color(0xFF45D8ED),
      shadow: Color(0xFF000000),
      surfaceTint: Color(0xFF006874),
    )
  );

  static ThemeData dartThemeData = ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF45D8ED),
      onPrimary: Color(0xFF00363D),
      primaryContainer: Color(0xFF004F58),
      onPrimaryContainer: Color(0xFF98F0FF),
      secondary: Color(0xFFFFB59F),
      onSecondary: Color(0xFF5E1600),
      secondaryContainer: Color(0xFF852300),
      onSecondaryContainer: Color(0xFFFFDBD0),
      tertiary: Color(0xFF4FD8EB),
      onTertiary: Color(0xFF00363D),
      tertiaryContainer: Color(0xFF004F58),
      onTertiaryContainer: Color(0xFF97F0FF),
      error: Color(0xFFFFB4AB),
      errorContainer: Color(0xFF93000A),
      onError: Color(0xFF690005),
      onErrorContainer: Color(0xFFFFDAD6),
      background: Color(0xFF191C1D),
      onBackground: Color(0xFFE1E3E3),
      surface: Color(0xFF191C1D),
      onSurface: Color(0xFFE1E3E3),
      surfaceVariant: Color(0xFF3F484A),
      onSurfaceVariant: Color(0xFFBFC8CA),
      outline: Color(0xFF899294),
      onInverseSurface: Color(0xFF191C1D),
      inverseSurface: Color(0xFFE1E3E3),
      inversePrimary: Color(0xFF006874),
      shadow: Color(0xFF000000),
      surfaceTint: Color(0xFF45D8ED),
    )
  );
  ///////////////////////////////



}