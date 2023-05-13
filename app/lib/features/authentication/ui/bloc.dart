import 'dart:async';
import 'package:auth_app/features/authentication/service/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Authentication State
class AuthState {}

class AuthInitial extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthUnauthenticated extends AuthState {}

// Authentication Events
abstract class AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String username;
  final String password;

  AuthLoginEvent(this.username, this.password);
}

class AuthLogoutEvent extends AuthEvent {}

// Authentication BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc(this.authService) : super(AuthInitial()) {
    on<AuthLoginEvent>((event, emit) async {
      emit(AuthInitial()); // Show loading state

      final isAuthenticated =
          await authService.authenticate(event.username, event.password);

      if (isAuthenticated) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthUnauthenticated());
      }
    });
    on<AuthLogoutEvent>((event, emit) async {
      await authService.logout();
      emit(AuthUnauthenticated());
    });
  }

}
