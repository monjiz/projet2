import 'dart:async';

import 'package:auth_firebase/data/repositories/user_repository.dart';
import 'package:auth_firebase/logique(bloc)/user/user_bloc.dart';
import 'package:auth_firebase/logique(bloc)/user/user_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Auth et Services
import 'package:firebase_core/firebase_core.dart'; // 👈 Corrigé : Firebase doit être importé
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

// Écrans
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); //  Important pour que Firebase fonctionne

  final apiService = ApiService();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              AnnouncementBloc(apiService: apiService),
        ),
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
        '/client': (context) => ClientScreen(), // 
        '/forgot_password': (context) => const ForgotPasswordScreen(), // 
      },
    );
  }
}
