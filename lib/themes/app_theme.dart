import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  primarySwatch: Colors.teal,
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Colors.teal[700],
  colorScheme: ColorScheme.light(secondary: Colors.orangeAccent),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith<Color>(
        (states) {
          if (states.contains(WidgetState.disabled))
            return Colors.white.withOpacity(0.55);

          return Colors.white;
        },
      ),
      overlayColor: WidgetStateProperty.all<Color>(
        Colors.teal.withOpacity(0.1),
      ),
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
        EdgeInsets.all(8.0),
      ),
      textStyle: WidgetStateProperty.all<TextStyle>(TextStyle(fontSize: 16.0)),
    ),
  ),
  textTheme: TextTheme(
    headlineMedium: TextStyle(
      color: Colors.black87,
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
      color: Colors.black87,
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: TextStyle(color: Colors.black87, fontSize: 16.0),
    bodyMedium: TextStyle(color: Colors.black54, fontSize: 14.0),
    titleMedium: TextStyle(color: Colors.grey[800], fontSize: 16.0),
    titleSmall: TextStyle(color: Colors.grey[800], fontSize: 14.0),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.teal[700],
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.teal[700],
    foregroundColor: Colors.white,
  ),
  cardColor: Colors.white,
  inputDecorationTheme: InputDecorationTheme(
    filled: false,
    fillColor: Colors.transparent,
    border: InputBorder.none,
    contentPadding: EdgeInsets.symmetric(vertical: 0),
    alignLabelWithHint: true,
    hintStyle: TextStyle(color: Colors.grey[600]),
  ),
  iconTheme: IconThemeData(
    color: Colors.teal[700],
  ),
  dividerColor: Colors.grey[400],
  listTileTheme: ListTileThemeData(
    iconColor: Colors.teal[700],
    textColor: Colors.black87,
  ),
  tabBarTheme: TabBarTheme(
    labelColor: Colors.white,
    unselectedLabelColor: Colors.white70,
    indicator: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.orangeAccent, width: 2.0),
      ),
    ),
  ),
);
