import 'package:auth_firebase/auth/auth_service.dart';
import 'package:auth_firebase/auth/forgotpassword/bloc/forgotpassword_event.dart';
import 'package:auth_firebase/auth/forgotpassword/bloc/forgotpassword_state.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthService authService;

  ForgotPasswordBloc({required this.authService}) : super(ForgotPasswordInitial()) {
    on<ForgotPasswordSubmitted>(_onForgotPasswordSubmitted);
  }

  Future<void> _onForgotPasswordSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(ForgotPasswordLoading());
    try {
      await authService.sendPasswordResetEmail(event.email);
      emit(ForgotPasswordSuccess());
    } catch (e) {
      emit(ForgotPasswordFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
