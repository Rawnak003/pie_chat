import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piechat/src/features/data/repositories/chat_repository.dart';
import 'package:piechat/src/features/logic/cubits/chats/chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _chatRepository;
  final String currentUserId;
  StreamSubscription? _messagesSubscription;
  StreamSubscription? _onlineStatusSubscription;
  StreamSubscription? _typingSubscription;
  StreamSubscription? _blockStatusSubscription;
  StreamSubscription? _amIBlockStatusSubscription;
  bool _isInChat = false;
  Timer? typingTimer;

  ChatCubit({
    required ChatRepository chatRepository,
    required this.currentUserId,
  }) : _chatRepository = chatRepository,
       super(const ChatState());

  void enterChat(String receiverId) async {
    _isInChat = true;
    emit(state.copyWith(status: ChatStatus.loading));
    try {
      final chatRoom = await _chatRepository.getOrCreateChatRoom(
        currentUserId,
        receiverId,
      );
      emit(
        state.copyWith(
          status: ChatStatus.loaded,
          chatRoomId: chatRoom.id,
          receiverId: receiverId,
        ),
      );
      subscribeToMessages(chatRoom.id);
      _subscribeToOnlineStatus(receiverId);
      _subscribeToTypingStatus(chatRoom.id);
      _subscribeToBlockStatus(receiverId);

      await _chatRepository.updateOnlineStatus(currentUserId, true);
    } catch (e) {
      emit(state.copyWith(status: ChatStatus.error, error: e.toString()));
    }
  }

  Future<void> sendMessage({
    required String content,
    required String receiverId,
  }) async {
    if (state.chatRoomId == null) return;
    try {
      await _chatRepository.sendMessage(
        chatRoomId: state.chatRoomId!,
        senderId: currentUserId,
        receiverId: receiverId,
        content: content,
      );
    } catch (e) {
      emit(state.copyWith(status: ChatStatus.error, error: e.toString()));
    }
  }

  void subscribeToMessages(String chatRoomId) {
    _messagesSubscription?.cancel();
    _messagesSubscription = _chatRepository
        .getMessages(chatRoomId)
        .listen(
          (messages) {
            if (_isInChat) {
              _markMessagesAsRead(chatRoomId);
            }
            emit(state.copyWith(messages: messages, error: null));
          },
          onError: (error) {
            emit(
              state.copyWith(status: ChatStatus.error, error: error.toString()),
            );
          },
        );
  }

  Future<void> _markMessagesAsRead(String chatRoomId) async {
    try {
      await _chatRepository.markMessagesAsRead(chatRoomId, currentUserId);
    } catch (e) {
      emit(state.copyWith(status: ChatStatus.error, error: e.toString()));
    }
  }

  Future<void> leaveChat() async {
    _isInChat = false;
  }

  void _subscribeToOnlineStatus(String userId) {
    _onlineStatusSubscription?.cancel();
    _onlineStatusSubscription = _chatRepository
        .getUserOnlineStatus(userId)
        .listen((status) {
          final isOnline = status['isOnline'] as bool;
          final lastSeen = status['lastSeen'] as Timestamp;
          emit(
            state.copyWith(
              isReceiverOnline: isOnline,
              receiverLastSeen: lastSeen,
            ),
          );
        },
      onError: (error) {
        emit(
          state.copyWith(status: ChatStatus.error, error: error.toString()),
        );
      },
    );
  }

  void _subscribeToTypingStatus(String chatRoomId) {
    _typingSubscription?.cancel();
    _typingSubscription = _chatRepository
        .getTypingStatus(chatRoomId)
        .listen((status) {
      final isTyping = status['isTyping'] as bool;
      final typingUserId = status['typingUserId'] as String?;
      emit(
        state.copyWith(
          isReceiverTyping: isTyping && typingUserId != currentUserId,
        ),
      );
    },
      onError: (error) {
        emit(
          state.copyWith(status: ChatStatus.error, error: error.toString()),
        );
      },
    );
  }

  void startTyping() {
    if (state.chatRoomId == null) return;
    typingTimer?.cancel();
    updateTypingStatus(true);
    typingTimer = Timer(const Duration(seconds: 3), () {
      updateTypingStatus(false);
    });
  }

  Future<void> updateTypingStatus(bool isTyping) async {
    if (state.chatRoomId == null) return;
    try {
      await _chatRepository.updateTypingStatus(state.chatRoomId!, currentUserId, isTyping);
    } catch (e) {
      emit(state.copyWith(status: ChatStatus.error, error: e.toString()));
    }
  }

  Future<void> blockUser(String userId) async {
    try {
      await _chatRepository.blockUser(currentUserId, userId);
    } catch (e) {
      emit(state.copyWith(status: ChatStatus.error, error: e.toString()));
    }
  }
  Future<void> unBlockUser(String userId) async {
    try {
      await _chatRepository.unBlockUser(currentUserId, userId);
    } catch (e) {
      emit(state.copyWith(status: ChatStatus.error, error: e.toString()));
    }
  }

  void _subscribeToBlockStatus(String otherUserId) {
    _blockStatusSubscription?.cancel();
    _blockStatusSubscription = _chatRepository
        .isUserBlocked(currentUserId, otherUserId)
        .listen((isBlocked) {
      emit(
        state.copyWith(isUserBlocked: isBlocked),
      );

      _amIBlockStatusSubscription?.cancel();
      _blockStatusSubscription = _chatRepository
          .isCurrentUserBlocked(currentUserId, otherUserId)
          .listen((isBlocked) {
        emit(
          state.copyWith(amIBlocked: isBlocked),
        );
      });
    }, onError: (error) {
      emit(state.copyWith(status: ChatStatus.error, error: error.toString()));
    });
  }

  Future<void> loadMoreMessages() async {
    if (state.status != ChatStatus.loaded || state.messages.isEmpty || !state.hasMoreMessages || state.isLoadingMore) return;
    try {
      emit(state.copyWith(isLoadingMore: true));
      final lastMessages = state.messages.last;
      final lastDoc = await _chatRepository.getChatRoomMessages(state.chatRoomId!).doc(lastMessages.id).get();
      final moreMessages = await _chatRepository.getMoreMessages(state.chatRoomId!, lastDocument: lastDoc);
      if (moreMessages.isEmpty) {
        emit(state.copyWith(hasMoreMessages: false, isLoadingMore: false));
        return;
      }
      emit(state.copyWith(messages: [...state.messages, ...moreMessages],hasMoreMessages: moreMessages.length >= 20, isLoadingMore: false));
    } catch (e) {
      emit(state.copyWith(status: ChatStatus.error, error: e.toString(), isLoadingMore: false));
    }
  }
}
