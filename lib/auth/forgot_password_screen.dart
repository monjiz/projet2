import 'package:auth_firebase/auth/forgotpassword/bloc/forgotpassword_bloc.dart';
import 'package:auth_firebase/auth/forgotpassword/bloc/forgotpassword_event.dart';
import 'package:auth_firebase/auth/forgotpassword/bloc/forgotpassword_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:auth_firebase/presentation/widgets/button.dart';
import 'package:auth_firebase/presentation/widgets/textfield.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          showToast("Reset email sent!");
          Navigator.pop(context);
        } else if (state is ForgotPasswordFailure) {
          showToast(state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is ForgotPasswordLoading;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF0D47A1),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0D47A1), Color(0xFF00E5FF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Forgot Password?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3B82F6),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Enter your email to receive a reset link.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 30),
                        CustomTextField(
                          label: "Email",
                          hint: "Enter your email",
                          controller: _emailController,
                          textColor: Colors.black,
                          hintColor: Colors.grey[500]!,
                          backgroundColor: Colors.white,
                          borderColor: Colors.grey[400]!,
                          borderRadius: 10,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        const SizedBox(height: 30),
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : CustomButton(
                                label: "Send Link",
                                onPressed: () {
                                  final email = _emailController.text.trim().toLowerCase();

                                  if (email.isEmpty) {
                                    showToast("Please enter your email.");
                                    return;
                                  }
                                  if (!isValidEmail(email)) {
                                    showToast("Invalid email address.");
                                    return;
                                  }

                                  context.read<ForgotPasswordBloc>().add(
                                        ForgotPasswordSubmitted(email),
                                      );
                                },
                                textColor: Colors.white,
                                backgroundColor: const Color(0xFF3B82F6),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                borderRadius: 10,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
