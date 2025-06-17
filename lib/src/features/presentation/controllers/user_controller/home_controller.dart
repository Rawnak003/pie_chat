import 'package:flutter/material.dart';
import 'package:piechat/src/core/routes/route_names.dart';
import 'package:piechat/src/core/routes/router.dart';
import 'package:piechat/src/core/utils/constants/colors.dart';
import 'package:piechat/src/features/data/repositories/auth_repository.dart';
import 'package:piechat/src/features/data/repositories/chat_repository.dart';
import 'package:piechat/src/features/data/repositories/contact_repository.dart';
import 'package:piechat/src/features/data/services/service_locator.dart';
import 'package:piechat/src/features/logic/cubits/auth/auth_cubit.dart';

class HomeController {
  final ContactRepository _contactRepository = getIt<ContactRepository>();
  final ChatRepository chatRepository = getIt<ChatRepository>();
  final String userId = getIt<AuthRepository>().currentUser!.uid;

  Future<void> onTapLogout(BuildContext context) async {
    await getIt<AuthCubit>().signOut();
    getIt<AppRouter>().pushNamedAndRemoveUntil(
      RoutesName.signIn,
      (route) => false,
    );
  }

  void showContactsList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "Contacts",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _contactRepository.getRegisteredContacts(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final contacts = snapshot.data!;
                    if (contacts.isEmpty) {
                      return const Center(child: Text("No contacts found"));
                    }
                    return ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        final contact = contacts[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColor.secondaryColor,
                            child: Text(contact["name"][0].toUpperCase()),
                          ),
                          title: Text(contact["name"]),
                          onTap: () => navigateToChatScreen(context, contact["id"], contact["name"]),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void navigateToChatScreen(BuildContext context, String receiverId, String receiverName) {
    getIt<AppRouter>().pushNamed(
      RoutesName.chatMessage,
      arguments: {
        'receiverId': receiverId,
        'receiverName': receiverName,
      },
    );
  }
}
