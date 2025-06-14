import 'package:flutter/material.dart';

class AppSpacing{
  static double screenHeight(BuildContext context){
    return MediaQuery.of(context).size.height;
  }
  static double screenWidth(BuildContext context){
    return MediaQuery.of(context).size.width;
  }
  static const double horizontalPadding = 16.00;
  static const double verticalPadding = 8.00;
}