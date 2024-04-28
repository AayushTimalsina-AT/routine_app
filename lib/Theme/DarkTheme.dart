import 'package:flutter/material.dart';

class DarkAppTheme {
  static ColorScheme kDarkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 6, 86, 232),
  );

  ThemeData darkTheme = ThemeData.dark().copyWith(
    useMaterial3: true,
    colorScheme: kDarkColorScheme,
    // appBarTheme: const AppBarTheme().copyWith(
    //   backgroundColor: kDarkColorScheme.onPrimaryContainer,
    //   foregroundColor: kDarkColorScheme.primaryContainer,
    // ),
    cardTheme: const CardTheme().copyWith(
      color: kDarkColorScheme.secondaryContainer,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kDarkColorScheme.primaryContainer,
        foregroundColor: kDarkColorScheme.onPrimaryContainer,
      ),
    ),
  );
}
