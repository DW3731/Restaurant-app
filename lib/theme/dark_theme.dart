import 'package:flutter/material.dart';

ThemeData dark = ThemeData(
  fontFamily: 'Roboto',
  primaryColor: const Color(0xFFce0303),
  secondaryHeaderColor: const Color(0xFFFA0909),
  disabledColor: const Color(0xFFA0AEC0),
  brightness: Brightness.dark,
  hintColor: const Color(0xFFbebebe),
  cardColor: Colors.black,
  shadowColor: Colors.white.withOpacity(0.03),
  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: const Color(0xFFce0303))),
  colorScheme: const ColorScheme.dark(primary: Color(0xFFce0303), secondary: Color(0xFFce0303)).copyWith(error: const Color(0xFFFA0909)),
  popupMenuTheme: const PopupMenuThemeData(color: Color(0xFF29292D), surfaceTintColor: Color(0xFF29292D)),
  dialogTheme: const DialogTheme(surfaceTintColor: Colors.white10),
  floatingActionButtonTheme: FloatingActionButtonThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(500)), elevation: 5.5),
  bottomAppBarTheme: const BottomAppBarTheme(color: Colors.black, height: 60, padding: EdgeInsets.symmetric(vertical: 5)),
  dividerTheme: const DividerThemeData(thickness: 0.2, color: Color(0xFFA0A4A8)),
  scaffoldBackgroundColor: const Color(0xff151414),
);