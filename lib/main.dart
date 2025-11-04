import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animeto_app/core/navigation/app_router.dart';
import 'package:animeto_app/core/theme/app_theme.dart';
import 'package:animeto_app/features/auth/presentation/providers/auth_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp.router(
        title: 'Animeto',
        theme: AppTheme.theme,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}