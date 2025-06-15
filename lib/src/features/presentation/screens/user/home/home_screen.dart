import 'package:flutter/material.dart';
import 'package:piechat/src/core/utils/constants/colors.dart';
import '../../../controllers/user_controller/home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = HomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats", style: Theme.of(context).textTheme.headlineSmall),
        actions: [
          IconButton(
            onPressed: () => controller.onTapLogout(context),
            icon: Icon(Icons.logout_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.showContactsList(context),
        child: Icon(Icons.message, color: AppColor.whiteColor),
      ),
      body: Center(child: Text('Home Screen')),
    );
  }
}
