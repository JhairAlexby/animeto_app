import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:animeto_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:animeto_app/features/feed/presentation/widgets/authenticated_network_image.dart';

class ProfileScreen extends StatefulWidget {
  static const String route = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().getUserProfile();
    });
  }

  Future<void> _pickAndUploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final provider = context.read<AuthProvider>();
      final messenger = ScaffoldMessenger.of(context);
      final theme = Theme.of(context);

      final ok = await provider.uploadProfilePhoto(pickedFile.path);

      if (context.mounted) {
        if (ok) {
          messenger.showSnackBar(
            const SnackBar(
              content: Text('Foto de perfil actualizada'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          messenger.showSnackBar(
            SnackBar(
              content: Text(provider.errorMessage ?? 'Error al subir la imagen'),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, provider, child) {
          if (provider.profileState == ProfileState.loading && provider.user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.profileState == ProfileState.error && provider.user == null) {
            return Center(child: Text(provider.errorMessage ?? 'Error desconocido'));
          }

          if (provider.user != null) {
            final user = provider.user!;
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        child: user.hasProfilePhoto
                            ? ClipOval(
                                child: AuthenticatedNetworkImage(
                                  url: 'https://animeto-api-production.up.railway.app/api/users/profile/photo',
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Text(
                                user.name.substring(0, 1).toUpperCase(),
                                style: const TextStyle(fontSize: 50),
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: _pickAndUploadImage,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                if (provider.isLoading)
                  const Center(child: CircularProgressIndicator()),
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
