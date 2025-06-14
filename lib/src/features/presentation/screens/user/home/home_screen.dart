import 'package:flutter/material.dart';

import '../../../../../core/routes/route_names.dart';
import '../../../../../core/routes/router.dart';
import '../../../../data/services/service_locator.dart';
import '../../../../logic/cubits/auth/auth_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        actions: [
          InkWell(
            onTap: () async {
              await getIt<AuthCubit>().signOut();
              getIt<AppRouter>().pushNamedAndRemoveUntil(RoutesName.signIn, (route) => false);
            },
            child: const Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      body: Center(child: Text('Home Screen')),
    );
  }
}
