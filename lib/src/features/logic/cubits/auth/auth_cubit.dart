import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piechat/src/features/logic/cubits/auth/auth_state.dart';
import '../../../data/repositories/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<User?>? authStateSubscription;

  AuthCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthState()) {
    _init();
  }

  void _init() {
    emit(state.copyWith(status: AuthStatus.initial));
    authStateSubscription = _authRepository.authStateChanges.listen((user,
    ) async {
      if (user != null) {
        try {
          final userData = await _authRepository.getUserData(user.uid);
          emit(
            state.copyWith(status: AuthStatus.authenticated, user: userData),
          );
        } catch (e) {
          emit(state.copyWith(status: AuthStatus.error, error: e.toString()));
        }
      } else {
        emit(state.copyWith(status: AuthStatus.unauthenticated));
      }
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading));
      final user = await _authRepository.signIn(
        email: email,
        password: password,
      );
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, error: e.toString()));
    }
  }

  Future<void> signUp({
    required String email,
    required String fullName,
    required String username,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading));
      final user = await _authRepository.signUp(
        email: email,
        fullName: fullName,
        username: username,
        phoneNumber: phoneNumber,
        password: password,
      );
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, error: e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      emit(state.copyWith(status: AuthStatus.unauthenticated, user: null));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, error: e.toString()));
    }
  }
}
