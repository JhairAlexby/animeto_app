import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:animeto_app/core/navigation/app_router.dart';
import 'package:animeto_app/core/services/api_service.dart';
import 'package:animeto_app/core/theme/app_theme.dart';

import 'package:animeto_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:animeto_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:animeto_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:animeto_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:animeto_app/features/auth/presentation/providers/auth_provider.dart';

import 'package:animeto_app/features/feed/data/datasources/publication_remote_data_source.dart';
import 'package:animeto_app/features/feed/data/repositories/publication_repository_impl.dart';
import 'package:animeto_app/features/feed/domain/repositories/publication_repository.dart';
import 'package:animeto_app/features/feed/presentation/providers/feed_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  timeago.setLocaleMessages('es', timeago.EsMessages());
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(
          create: (_) => ApiService(),
        ),

        Provider<AuthLocalDataSource>(
          create: (_) =>
              AuthLocalDataSourceImpl(sharedPreferences: sharedPreferences),
        ),
        Provider<AuthRemoteDataSource>(
          create: (context) => AuthRemoteDataSourceImpl(
            apiService: context.read<ApiService>(),
          ),
        ),
        Provider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(
            remoteDataSource: context.read<AuthRemoteDataSource>(),
            localDataSource: context.read<AuthLocalDataSource>(),
            apiService: context.read<ApiService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            authRepository: context.read<AuthRepository>(),
          ),
        ),

        Provider<PublicationRemoteDataSource>(
          create: (context) => PublicationRemoteDataSourceImpl(
            apiService: context.read<ApiService>(),
          ),
        ),
        Provider<PublicationRepository>(
          create: (context) => PublicationRepositoryImpl(
            remoteDataSource: context.read<PublicationRemoteDataSource>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => FeedProvider(
            publicationRepository: context.read<PublicationRepository>(),
          ),
        ),
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