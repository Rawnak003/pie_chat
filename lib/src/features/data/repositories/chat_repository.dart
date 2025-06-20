import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:piechat/src/features/data/models/chat_room_model.dart';
import 'package:piechat/src/features/data/models/user_model.dart';
import 'package:piechat/src/features/data/services/base_repository.dart';

import '../models/chat_message_model.dart';

class ChatRepository extends BaseRepository {
  CollectionReference get chatRooms => firestore.collection('chatRooms');

  CollectionReference getChatRoomMessages(String roomId) {
    return chatRooms.doc(roomId).collection('messages');
  }

  Future<ChatRoomModel> getOrCreateChatRoom(
    String currentUserId,
    String otherUserId,
  ) async {
    final users = [currentUserId, otherUserId]..sort();
    final roomId = users.join('_');

    final chatRoomSnapshot = await chatRooms.doc(roomId).get();
    if (chatRoomSnapshot.exists) {
      return ChatRoomModel.fromFirestore(chatRoomSnapshot);
    }

    final currentUserData =
        (await firestore.collection('users').doc(currentUserId).get()).data()
            as Map<String, dynamic>;
    final otherUserData =
        (await firestore.collection('users').doc(otherUserId).get()).data()
            as Map<String, dynamic>;

    final participantsName = {
      currentUserId: currentUserData['fullName']?.toString() ?? '',
      otherUserId: otherUserData['fullName']?.toString() ?? '',
    };

    final newRoom = ChatRoomModel(
      id: roomId,
      participants: users,
      participantsName: participantsName,
      lastReadTime: {
        currentUserId: Timestamp.now(),
        otherUserId: Timestamp.now(),
      },
    );

    await chatRooms.doc(roomId).set(newRoom.toMap());
    return newRoom;
  }

  Future<void> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String receiverId,
    required String content,
    MessageType type = MessageType.text,
  }) async {
    final batch = firestore.batch();
    final messageDoc = getChatRoomMessages(chatRoomId).doc();
    final message = ChatMessageModel(
      id: messageDoc.id,
      chatRoomId: chatRoomId,
      senderId: senderId,
      receiverId: receiverId,
      content: content,
      type: type,
      status: MessageStatus.sent,
      timestamp: Timestamp.now(),
      readBy: [senderId],
    );

    batch.set(messageDoc, message.toMap());
    batch.update(chatRooms.doc(chatRoomId), {
      "lastMessage": content,
      "lastMessageSenderId": senderId,
      "lastMessageTime": message.timestamp,
    });
    await batch.commit();
  }

  Stream<List<ChatMessageModel>> getMessages(
    String chatRoomId, {
    DocumentSnapshot? lastDocument,
  }) {
    var query = getChatRoomMessages(
      chatRoomId,
    ).orderBy('timestamp', descending: true).limit(20);
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }
    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatMessageModel.fromFirestore(doc))
          .toList();
    });
  }

  Future<List<ChatMessageModel>> getMoreMessages(
    String chatRoomId, {
    required DocumentSnapshot lastDocument,
  }) async {
    final query = getChatRoomMessages(chatRoomId)
        .orderBy('timestamp', descending: true)
        .startAfterDocument(lastDocument)
        .limit(20);
    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => ChatMessageModel.fromFirestore(doc))
        .toList();
  }

  Stream<List<ChatRoomModel>> getChatRooms(String userId) {
    return chatRooms
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ChatRoomModel.fromFirestore(doc))
              .toList();
        });
  }

  Stream<int> getUnreadCount(String chatRoomId, String userId) {
    return getChatRoomMessages(chatRoomId)
        .where('receiverId', isEqualTo: userId)
        .where('status', isEqualTo: MessageStatus.sent.toString())
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Future<void> markMessagesAsRead(String chatRoomId, String userId) async {
    try {
      final batch = firestore.batch();

      final unreadMessages = await getChatRoomMessages(chatRoomId)
          .where(
        "receiverId",
        isEqualTo: userId,
      )
          .where('status', isEqualTo: MessageStatus.sent.toString())
          .get();
      for (final doc in unreadMessages.docs) {
        batch.update(doc.reference, {
          'readBy': FieldValue.arrayUnion([userId]),
          'status': MessageStatus.read.toString(),
        });
        await batch.commit();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Stream<Map<String, dynamic>> getUserOnlineStatus(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map((snapshot) {
      final data = snapshot.data();
      return {
        'isOnline': data?['isOnline'] ?? false,
        'lastSeen': data?['lastSeen'],
      };
    });
  }

  Future<void> updateOnlineStatus(String userId, bool isOnline) async {
    await firestore.collection('users').doc(userId).update({
      'isOnline': isOnline,
      'lastSeen': Timestamp.now(),
    });
  }

  Stream<Map<String, dynamic>> getTypingStatus(String chatRoomId) {
    return chatRooms.doc(chatRoomId).snapshots().map((snapshot) {
      if(!snapshot.exists){
        return {
          'isTyping': false,
          'typingUserId': null,
        };
      }
      final data = snapshot.data() as Map<String, dynamic>;
      return {
        'isTyping': data['isTyping'] ?? false,
        'typingUserId': data['typingUserId'],
      };
    });
  }

  Future<void> updateTypingStatus(String chatRoomId, String userId, bool isTyping) async {
    try {
      final doc = await chatRooms.doc(chatRoomId).get();
      if(!doc.exists){
        return;
      }
      await chatRooms.doc(chatRoomId).update({
        'isTyping': isTyping,
        'typingUserId': isTyping ? userId : null,
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> blockUser(String currentUserId, String blockedUserId) async {
    final userRef = firestore.collection('users').doc(currentUserId);
    await userRef.update({'blockedUsers': FieldValue.arrayUnion([blockedUserId])});
  }

  Future<void> unBlockUser(String currentUserId, String blockedUserId) async {
    final userRef = firestore.collection('users').doc(currentUserId);
    await userRef.update({'blockedUsers': FieldValue.arrayRemove([blockedUserId])});
  }

  Stream<bool> isUserBlocked(String currentUserId, String otherUserId) {
    return firestore.collection('users').doc(currentUserId).snapshots().map((snapshot) {
      final userData = UserModel.fromFirestore(snapshot);
      return userData.blockedUsers.contains(otherUserId);
    });
  }
  Stream<bool> isCurrentUserBlocked(String currentUserId, String otherUserId) {
    return firestore.collection('users').doc(otherUserId).snapshots().map((snapshot) {
      final userData = UserModel.fromFirestore(snapshot);
      return userData.blockedUsers.contains(currentUserId);
    });
  }
}
