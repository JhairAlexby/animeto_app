import 'package:flutter/material.dart';

class AuthTextField extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isPassword;
  final TextEditingController controller;

  const AuthTextField({
    super.key,
    required this.icon,
    required this.label,
    this.isPassword = false,
    required this.controller,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: Icon(widget.icon),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Este campo es obligatorio';
        }
        if (widget.label.toLowerCase().contains('email') &&
            !value.contains('@')) {
          return 'Por favor ingresa un email válido';
        }
        if (widget.isPassword && value.length < 6) {
          return 'La contraseña debe tener al menos 6 caracteres';
        }
        return null;
      },
    );
  }
}