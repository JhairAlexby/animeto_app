import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animeto_app/features/auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  static const String route = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().getUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, provider, child) {
          if (provider.profileState == ProfileState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.profileState == ProfileState.error) {
            return Center(child: Text(provider.errorMessage ?? 'Error desconocido'));
          }

          if (provider.profileState == ProfileState.loaded && provider.user != null) {
            final user = provider.user!;
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    child: Text(
                      user.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Nombre'),
                  subtitle: Text(user.name),
                ),
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('Email'),
                  subtitle: Text(user.email),
                ),
                ListTile(
                  leading: const Icon(Icons.date_range_outlined),
                  title: const Text('Miembro desde'),
                  subtitle: Text(user.createdAt.toLocal().toString().split(' ')[0]),
                ),
              ],
            );
          }

          return const Center(child: Text('Iniciando...'));
        },
      ),
    );
  }
}