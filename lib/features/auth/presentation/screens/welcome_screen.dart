import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animeto_app/core/theme/app_colors.dart';
import 'package:animeto_app/features/auth/presentation/widgets/responsive_layout.dart';
import 'package:animeto_app/features/auth/presentation/screens/login_screen.dart';
import 'package:animeto_app/features/auth/presentation/screens/register_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String route = '/';

  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                AnimatedOpacity(
                  opacity: _isVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 800),
                  child: Column(
                    children: [
                      Icon(
                        Icons.filter_vintage,
                        size: 100,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Animeto',
                        style: textTheme.headlineLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tu red social de anime y manga',
                        style: textTheme.titleMedium
                            ?.copyWith(color: AppColors.onBackground),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 2),
                AnimatedSlide(
                  offset: _isVisible ? Offset.zero : const Offset(0, 0.5),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeInOut,
                  child: AnimatedOpacity(
                    opacity: _isVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 700),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: () => context.push(LoginScreen.route),
                          child: const Text('Iniciar Sesión'),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () => context.push(RegisterScreen.route),
                          child: const Text('Registrarse'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}