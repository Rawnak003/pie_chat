import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:piechat/src/features/data/models/user_model.dart';
import 'package:piechat/src/features/data/services/base_repository.dart';

class AuthRepository extends BaseRepository {
  Stream<User?> get authStateChanges => auth.authStateChanges();
  // sign up
  Future<UserModel> signUp({
    required String email,
    required String fullName,
    required String username,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final formattedPhoneNumber = phoneNumber
          .replaceAll(RegExp(r'\s+'), '')
          .replaceFirst(RegExp(r'^\+88'), '');
      final emailExists = await checkEmailExists(email);
      if (emailExists) {
        throw "An account with the same email already exists";
      }
      final phoneNumberExists = await checkPhoneExists(formattedPhoneNumber);
      if (phoneNumberExists) {
        throw "An account with the same phone already exists";
      }
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        throw "Failed to create user";
      }
      final user = UserModel(
        uid: userCredential.user!.uid,
        fullName: fullName,
        username: username,
        email: email,
        phoneNumber: formattedPhoneNumber,
        password: password,
      );
      await saveUserData(user);
      return user;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> saveUserData(UserModel userModel) async {
    try {
      await firestore
          .collection("users")
          .doc(userModel.uid)
          .set(userModel.toMap());
    } catch (e) {
      throw "Failed to save user data";
    }
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      final methods = await auth.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkPhoneExists(String phoneNumber) async {
    try {
      final formattedPhoneNumber = phoneNumber
          .replaceAll(RegExp(r'\s+'), '')
          .replaceFirst(RegExp(r'^\+88'), '');
      final querySnapshot = await firestore
          .collection("users")
          .where("phoneNumber", isEqualTo: formattedPhoneNumber)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // sign in
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        throw "User not found";
      }
      final userData = await getUserData(userCredential.user!.uid);
      return userData;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<UserModel> getUserData(String uid) async {
    try {
      final doc = await firestore.collection("users").doc(uid).get();
      if (!doc.exists) {
        throw "User not exist";
      }
      final user = UserModel.fromFirestore(doc);
      return user;
    } catch (e) {
      throw "Failed to get user data";
    }
  }

  // sign out
  Future<void> signOut() async {
    await auth.signOut();
  }
}
