/*

Auth Repository - Outlines the possible auth operations for this app.

*/

// ignore: depend_on_referenced_packages
import 'package:social_app_jose_gael/features/auth/domain/entities/app_user.dart';

abstract class AuthRepo {
  Future<AppUser?> loginWithEmailPassword(String email, String password);
  Future<AppUser?> registerWithEmailPassword(
      String name, String email, String password);
  Future<void> logout();
  Future<AppUser?> getCurrentUser();
}
