import 'package:flutter/material.dart';

abstract final class Brand {
  static const purple = Color(0xFF5421EB),
      navy = Color(0xFF0B1630),
      lavender = Color(0xFF9B83F5),
      background = Color(0xFFF7F7FC);
  static const muted = Color(0xFF62677A), line = Color(0xFFE4E5EE);
}

ThemeData appTheme({bool highContrast = false}) {
  final scheme = ColorScheme.fromSeed(
    seedColor: Brand.purple,
    primary: Brand.purple,
    onPrimary: Colors.white,
    surface: Colors.white,
    onSurface: Brand.navy,
    error: const Color(0xFFAD2034),
  );
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: 'PlusJakartaSans',
    scaffoldBackgroundColor: Brand.background,
  );
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: highContrast ? Brand.navy : Brand.line),
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: Brand.navy,
      displayColor: Brand.navy,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Brand.background,
      foregroundColor: Brand.navy,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Brand.navy,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: highContrast ? Brand.navy : Brand.line),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: Brand.purple, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      errorMaxLines: 3,
      labelStyle: const TextStyle(color: Brand.muted),
      floatingLabelStyle: const TextStyle(color: Brand.purple),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 54),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        textStyle: const TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 52),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        side: BorderSide(color: highContrast ? Brand.navy : Brand.line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      indicatorColor: const Color(0xFFECE5FF),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 11,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w700
              : FontWeight.w500,
          color: states.contains(WidgetState.selected)
              ? Brand.purple
              : Brand.muted,
        ),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      side: const BorderSide(color: Brand.line),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    dividerTheme: const DividerThemeData(color: Brand.line, space: 1),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Brand.navy,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
