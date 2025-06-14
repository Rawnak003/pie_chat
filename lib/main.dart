import 'package:flutter/material.dart';
import 'package:piechat/src/core/app/app.dart';
import 'package:piechat/src/features/data/services/service_locator.dart';

void main() async {
  await setupServiceLocator();
  runApp(PieChat());
}

