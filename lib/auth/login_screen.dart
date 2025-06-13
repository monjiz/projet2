import 'package:auth_firebase/auth/login/bloc/login_bloc.dart';
import 'package:auth_firebase/auth/login/bloc/login_event.dart';
import 'package:auth_firebase/auth/login/bloc/login_state.dart';
import 'package:auth_firebase/presentation/screens/AdminScreens/admin_screen.dart';
import 'package:auth_firebase/presentation/screens/ClientScreens/client_screen.dart';
import 'package:auth_firebase/presentation/screens/WorkerScreens/travailleur_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:auth_firebase/auth/auth_service.dart';
import 'package:auth_firebase/auth/forgot_password_screen.dart';
import 'package:auth_firebase/auth/signup_screen.dart';

import 'package:auth_firebase/presentation/widgets/button.dart';
import 'package:auth_firebase/presentation/widgets/textfield.dart';
import 'package:auth_firebase/presentation/widgets/socialButton.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isPasswordVisible = false;

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  void initState() {
    super.initState();
    // Vérifier si un utilisateur est déjà connecté
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoginBloc>().add(CheckCurrentUser());
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(authService: AuthService()),
      child: Scaffold(
        backgroundColor: const Color(0xFF0D47A1),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0D47A1),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: BlocConsumer<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is LoginSuccess && context.mounted) {
                    Widget targetScreen;
                    if (state.type == 'admin') {
                      targetScreen = const HomeScreen();
                    } else if (state.type == 'client') {
                      targetScreen = const ClientScreen();
                    } else if (state.type == 'worker') {
                      targetScreen = const TravailleurScreen();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Type d\'utilisateur inconnu')),
                      );
                      return;
                    }
                    
                    // Navigation avec suppression de l'historique
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => targetScreen),
                      (route) => false,
                    );
                  } else if (state is LoginFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
                builder: (context, state) {
                  final isLoading = state is LoginLoading;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 0),
                            Image.asset(
                              'assets/images/logo2.png',
                              height: 100,
                              width: 200,
                              fit: BoxFit.contain,
                            ),
                            const Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'RecklessNeue',
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Don't have an account? "),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SignupScreen(),
                                    ),
                                  ),
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: Color(0xFF3B82F6),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      CustomTextField(
                        label: "Email",
                        hint: "Enter your email",
                        controller: _email,
                        textColor: Colors.black,
                        hintColor: Colors.grey[600]!,
                        backgroundColor: Colors.white,
                        borderColor: Colors.grey[300]!,
                        borderRadius: 12,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 12),
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        label: "Password",
                        hint: "Enter your password",
                        controller: _password,
                        isPassword: true,
                        obscureText: !_isPasswordVisible,
                        textColor: Colors.black,
                        hintColor: Colors.grey[600]!,
                        backgroundColor: Colors.white,
                        borderColor: Colors.grey[300]!,
                        borderRadius: 12,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 12),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey[600],
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Color(0xFF3B82F6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton.icon(
                              icon:
                                  const Icon(Icons.login, color: Colors.white),
                              label: const Text(
                                'Sign In',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              onPressed: () {
                                final email = _email.text.trim().toLowerCase();
                                final password = _password.text.trim();
                                if (email.isEmpty || password.isEmpty) {
                                  _showToast(
                                      "Veuillez remplir tous les champs.");
                                  return;
                                }
                                context.read<LoginBloc>().add(
                                      LoginSubmitted(
                                        email: email,
                                        password: password,
                                      ),
                                    );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3B82F6),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 99),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                      const SizedBox(height: 10),
                      const Center(
                        child: Text(
                          'Or',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SocialButton(
                        icon: 'assets/images/google.png',
                        label: 'Continue with Google',
                        onPressed: () async => context.read<LoginBloc>().add(
                                GoogleSignInSubmitted(
                                    context: context),
                              ),
                        size: 26,
                        borderColor: Colors.grey[300]!,
                        borderRadius: 10,
                        backgroundColor: Colors.white,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}