import 'package:flutter/material.dart';
import 'package:piechat/src/core/utils/constants/colors.dart';
import 'package:piechat/src/core/utils/constants/strings.dart';
import 'package:piechat/src/features/presentation/controllers/user_controller/home_controller.dart';
import 'package:piechat/src/features/presentation/screens/user/home/widgets/chat_list_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = HomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.chats),
        actions: [
          IconButton(
            onPressed: () => homeController.onTapLogout(context),
            icon: Icon(Icons.logout_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => homeController.showContactsList(context),
        child: Icon(Icons.message, color: AppColor.whiteColor),
      ),
      body: StreamBuilder(
        stream: homeController.chatRepository.getChatRooms(homeController.userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No chats found'));
          }
          final chats = snapshot.data!;
          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              return ChatListTile(
                chat: chat,
                currentUserId: homeController.userId,
                onTap: () {
                  final otherUserId = chat.participants.firstWhere((id) => id != homeController.userId);
                  final otherUserName = chat.participantsName?[otherUserId] ?? "Unknown";
                  homeController.navigateToChatScreen(context, otherUserId, otherUserName);
                },
              );
            },
          );
        },
      ),
    );
  }
}
