
import 'package:social_app_jose_gael/features/auth/domain/entities/app_user.dart';

abstract class AuthState {}


class AuthInitial extends AuthState {}


class Authloading extends AuthState {}


class Authenticated extends AuthState {
  final AppUser user;
  Authenticated(this.user);
}


class Unauthenticated extends AuthState {}


class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
