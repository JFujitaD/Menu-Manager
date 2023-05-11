import 'package:flutter/material.dart';

import 'constants.dart' as Constants;

final primaryTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    color: Constants.orange,
    foregroundColor: Constants.creamyWhite,
  ),
  scaffoldBackgroundColor: Constants.creamyWhite,
  iconTheme: const IconThemeData(
    color: Constants.teal,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Constants.orange,
    unselectedItemColor: Constants.creamyWhite,
    selectedItemColor: Constants.darkYellow,
  ),
  cardTheme: const CardTheme(
    color: Constants.teal,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Constants.teal,
      foregroundColor: Constants.creamyWhite,
    ),
  ),
);