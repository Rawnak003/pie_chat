import 'package:flutter/material.dart';
import '../utils/constants/strings.dart';

class PieChat extends StatefulWidget {
  const PieChat({super.key});

  @override
  State<PieChat> createState() => _PieChatState();
}

class _PieChatState extends State<PieChat> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
    );
  }
}