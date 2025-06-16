import 'package:auth_firebase/auth/signup/bloc/signup_bloc.dart';
import 'package:auth_firebase/auth/signup/bloc/signup_event.dart';
import 'package:auth_firebase/auth/signup/bloc/signup_state.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:auth_firebase/auth/auth_service.dart';
import 'package:auth_firebase/auth/login_screen.dart';
import 'package:auth_firebase/presentation/widgets/button.dart';
import 'package:auth_firebase/presentation/widgets/socialButton.dart';
import 'package:auth_firebase/presentation/widgets/textfield.dart';
import 'package:auth_firebase/auth/login/bloc/login_event.dart' as login;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String _selectedRole = 'Client';
  final List<String> roles = ['Client', 'Worker'];
  String? _confirmPasswordError;

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

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupBloc(authService: AuthService()),
      child: Scaffold(
        backgroundColor: const Color(0xFF0D47A1), // Même couleur que LoginScreen
        appBar: AppBar(
          backgroundColor: const Color(0xFF0D47A1),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: BlocConsumer<SignupBloc, SignupState>(
                  listener: (context, state) {
                    if (state is SignupSuccess) {
                      showToast("Inscription réussie !");
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    } else if (state is SignupFailure) {
                      showToast(state.error);
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is SignupLoading;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/logo2.png',
                                height: 100,
                                width: 200,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 0),
                              const Text(
                                'Sign Up',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                             
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    text: "Already have an account? ",
                                    style: const TextStyle(
                                      fontSize: 19,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Sign In",
                                        style: const TextStyle(
                                          color: Color(0xFF3B82F6),
                                          fontWeight: FontWeight.w600,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const LoginScreen()),
                                            );
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        CustomTextField(
                          label: "Name",
                          hint: "Enter your name",
                          controller: _name,
                          textColor: Colors.black,
                          hintColor: Colors.grey[600]!,
                          backgroundColor: Colors.white,
                          borderColor: Colors.grey[300]!,
                          borderRadius: 12,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 12),
                        ),
                        const SizedBox(height: 8),
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
                        const SizedBox(height: 8),
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
                        const SizedBox(height: 8),
                        TextField(
                          controller: _confirmPassword,
                          obscureText: !_isConfirmPasswordVisible,
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            hintText: "Confirm your password",
                            errorText: _confirmPasswordError,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey[600],
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _confirmPasswordError != null
                                    ? Colors.red
                                    : Colors.grey[300]!,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedRole,
                          items: roles
                              .map((role) => DropdownMenuItem(
                                    value: role,
                                    child: Text(
                                      role,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) =>
                              setState(() => _selectedRole = value!),
                          decoration: InputDecoration(
                            labelText: "Role",
                            labelStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xFF3B82F6)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : CustomButton(
                                label: "Register",
                                onPressed: () {
                                  final name = _name.text.trim();
                                  final email = _email.text.trim().toLowerCase();
                                  final password = _password.text.trim();
                                  final confirmPassword =
                                      _confirmPassword.text.trim();

                                  setState(() {
                                    _confirmPasswordError =
                                        password != confirmPassword
                                            ? "Les mots de passe ne correspondent pas"
                                            : null;
                                  });

                                  if (name.isEmpty ||
                                      email.isEmpty ||
                                      password.isEmpty ||
                                      confirmPassword.isEmpty) {
                                    showToast("Veuillez remplir tous les champs");
                                    return;
                                  }

                                  if (_confirmPasswordError != null) {
                                    return;
                                  }

                                  context.read<SignupBloc>().add(
                                        SignupSubmitted(
                                          name: name,
                                          email: email,
                                          password: password,
                                          confirmPassword: confirmPassword,
                                          role: _selectedRole,
                                        ),
                                      );
                                },
                                textColor: Colors.white,
                                backgroundColor: const Color(0xFF3B82F6),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                borderRadius: 12,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 17, horizontal: 113),
                              ),
                        /*const SizedBox(height: 8),
                        const Center(
                          child: Text(
                            'Or',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SocialButton(
                          icon: 'assets/images/google.png',
                          label: 'Continue with Google',
                          onPressed: () async => context.read<SignupBloc>().add(
                              login.GoogleSignInSubmitted() as SignupEvent),
                          size: 23,
                          borderColor: Colors.grey[300]!,
                          borderRadius: 10,
                          backgroundColor: Colors.white,
                        ),*/
                        /*const SizedBox(height: 8),
                        SocialButton(
                          icon: 'assets/images/facebook.png',
                          label: 'Continue with Facebook',
                          onPressed: () async {
                            showToast("Facebook signup not implemented");
                          },
                          size: 26,
                          borderColor: Colors.grey[300]!,
                          borderRadius: 10,
                          backgroundColor: Colors.white,
                        ),*/
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}