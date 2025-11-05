import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:animeto_app/features/auth/presentation/widgets/responsive_layout.dart';
import 'package:animeto_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:animeto_app/features/auth/presentation/widgets/auth_text_field.dart';

class RegisterScreen extends StatefulWidget {
  static const String route = '/register';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_passwordController.text != _confirmPasswordController.text) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Las contraseñas no coinciden'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final messenger = ScaffoldMessenger.of(context);
      final theme = Theme.of(context);
      final navigator = GoRouter.of(context);
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );

      if (!context.mounted) return;

      if (success) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Registro exitoso. Ya puedes iniciar sesión.'),
            backgroundColor: Colors.green,
          ),
        );
        navigator.pop();
      } else {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              authProvider.errorMessage ?? 'Error al registrarse',
            ),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Cuenta'),
      ),
      body: ResponsiveLayout(
        mobileBody: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Únete a Animeto',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  AuthTextField(
                    controller: _nameController,
                    icon: Icons.person_outline,
                    label: 'Nombre',
                  ),
                  const SizedBox(height: 20),
                  AuthTextField(
                    controller: _emailController,
                    icon: Icons.email_outlined,
                    label: 'Email',
                  ),
                  const SizedBox(height: 20),
                  AuthTextField(
                    controller: _passwordController,
                    icon: Icons.lock_outline,
                    label: 'Contraseña',
                    isPassword: true,
                  ),
                  const SizedBox(height: 20),
                  AuthTextField(
                    controller: _confirmPasswordController,
                    icon: Icons.lock_outline,
                    label: 'Confirmar Contraseña',
                    isPassword: true,
                  ),
                  const SizedBox(height: 32),
                  authProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () => _submit(context),
                          child: const Text('Registrarse'),
                        ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('¿Ya tienes cuenta? Inicia sesión'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}