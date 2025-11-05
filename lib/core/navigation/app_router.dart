import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animeto_app/features/auth/presentation/screens/login_screen.dart';
import 'package:animeto_app/features/auth/presentation/screens/register_screen.dart';
import 'package:animeto_app/features/auth/presentation/screens/welcome_screen.dart';
import 'package:animeto_app/features/feed/presentation/screens/home_screen.dart';
import 'package:animeto_app/features/feed/presentation/screens/create_post_screen.dart';

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: WelcomeScreen.route,
    routes: [
      GoRoute(
        path: WelcomeScreen.route,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: LoginScreen.route,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: RegisterScreen.route,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const RegisterScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: HomeScreen.route,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: CreatePostScreen.route,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const CreatePostScreen(),
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) =>
                  FadeTransition(opacity: animation, child: child),
        ),
      ),
    ],
  );
}