import 'dart:async';

import 'package:auth_firebase/data/repositories/annonce_repository.dart';
import 'package:auth_firebase/data/repositories/user_repository.dart';
import 'package:auth_firebase/logique(bloc)/user/user_bloc.dart';
import 'package:auth_firebase/logique(bloc)/user/user_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firebase_core/firebase_core.dart'; // Firebase import corrigé
import 'package:shared_preferences/shared_preferences.dart'; // IMPORT MANQUANT

import 'package:auth_firebase/auth/auth_service.dart';
import 'package:auth_firebase/data/services/api_service.dart';
import 'package:auth_firebase/data/repositories/client_repository.dart';
import 'package:auth_firebase/data/repositories/role_permission_repository_impl.dart';

// BLoCs
import 'package:auth_firebase/logique(bloc)/annonce/annonce_bloc.dart';
import 'package:auth_firebase/logique(bloc)/annonce/annonce_event.dart';
import 'package:auth_firebase/logique(bloc)/notification/notification_bloc.dart';
import 'package:auth_firebase/logique(bloc)/notification/notification_event.dart';
import 'package:auth_firebase/logique(bloc)/permissions/role_permission_bloc.dart';
import 'package:auth_firebase/logique(bloc)/client/client_bloc.dart';
import 'package:auth_firebase/logique(bloc)/client/client_event.dart';
import 'package:auth_firebase/auth/login/bloc/login_bloc.dart';
import 'package:auth_firebase/auth/forgotpassword/bloc/forgotpassword_bloc.dart';

// Screens
import 'package:auth_firebase/auth/forgot_password_screen.dart';
import 'package:auth_firebase/auth/login_screen.dart';
import 'package:auth_firebase/presentation/screens/paimentScreens/add_card_screen.dart';
import 'package:auth_firebase/presentation/screens/paimentScreens/payment_details_screen.dart';
import 'package:auth_firebase/presentation/screens/WelcomeScreens/onboarding_screen1.dart';
import 'package:auth_firebase/presentation/screens/WelcomeScreens/onboarding_screen2.dart';
import 'package:auth_firebase/presentation/screens/WelcomeScreens/splash_screen.dart';
import 'package:auth_firebase/presentation/screens/WelcomeScreens/welcome.dart';
import 'package:auth_firebase/presentation/screens/ClientScreens/client_screen.dart';
import 'package:auth_firebase/presentation/screens/ClientScreens/client_profil_screen.dart';
import 'package:auth_firebase/presentation/screens/ClientScreens/ClientEditProfileScreen.dart';

import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token') ?? '';

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => NotificationBloc()..add(LoadNotifications()),
        ),
        BlocProvider(
          create: (_) => RolePermissionBloc(RolePermissionRepositoryImpl()),
        ),
        BlocProvider(
          create: (_) => LoginBloc(authService: AuthService()),
        ),
        BlocProvider(
          create: (_) => ForgotPasswordBloc(authService: AuthService()),
        ),
        BlocProvider(
          create: (_) => ClientBloc(clientRepository: ClientRepository())
            ..add(LoadClientDashboard()),
        ),
        BlocProvider(
          create: (_) => UserBloc(UserRepository())..add(LoadUsers()),
        ),
       BlocProvider(
  create: (context) => AnnouncementBloc(
    repository: AnnouncementRepository(),
  )..add(LoadAnnouncements()),
)
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => const SplashScreen(),
        '/welcome': (context) => const Welcome(),
        '/profile': (context) => const ClientProfileScreen(),
        '/edit_profile': (context) => const ClientEditProfileScreen(),
        '/onboarding1': (context) => const OnboardingScreen1(),
        '/onboarding2': (context) => const OnboardingScreen2(),
        '/login': (context) => const LoginScreen(),
        '/splash': (context) => const SplashScreen(),
        '/addcard': (context) => AddCardScreen(),
        '/paiment': (context) => PaymentDetailsScreen(),
        '/client': (context) => ClientScreen(),
        '/forgot_password': (context) => const ForgotPasswordScreen(),
      },
    );
  }
}
