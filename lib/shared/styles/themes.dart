import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shop_app/shared/styles/colors.dart';

ThemeData lightTheme = ThemeData(
  primarySwatch: defaultColor,
  floatingActionButtonTheme:
      FloatingActionButtonThemeData(backgroundColor: defaultColor),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark),
    titleSpacing: 20,
    backgroundColor: Colors.white,
    elevation: 0.0,
    titleTextStyle: TextStyle(
        color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
    iconTheme: IconThemeData(color: Colors.black),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: defaultColor,
      unselectedItemColor: Colors.grey,
      elevation: 20.0),
  textTheme: const TextTheme(
    bodyText1: TextStyle(
        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
  ),
  fontFamily: 'Jannah',
);
ThemeData darkTheme = ThemeData(
  primarySwatch: defaultColor,
  floatingActionButtonTheme:
      FloatingActionButtonThemeData(backgroundColor: defaultColor),
  scaffoldBackgroundColor: HexColor('333739'),
  appBarTheme: AppBarTheme(
    // backwardsCompatibility false make me
    // able to control status bar values if true i can't
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: HexColor('333739'),
        statusBarIconBrightness: Brightness.light),
    titleSpacing: 20,
    backgroundColor: HexColor('333739'),
    elevation: 0.0,
    titleTextStyle: const TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    iconTheme: const IconThemeData(color: Colors.white),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: HexColor('333739'),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: defaultColor,
      unselectedItemColor: Colors.grey,
      elevation: 20.0),
  textTheme: const TextTheme(
    bodyText1: TextStyle(
        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
  ),
  fontFamily: 'Jannah',
);
