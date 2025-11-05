import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:animeto_app/features/feed/presentation/providers/feed_provider.dart';

class CreatePostScreen extends StatefulWidget {
  static const String route = '/posts/create';
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _currentChaptersController = TextEditingController();
  final _tagsController = TextEditingController();

  String _type = 'manga';
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _descriptionController.dispose();
    _currentChaptersController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _submit(BuildContext context) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final messenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);
    final navigator = GoRouter.of(context);
    final provider = context.read<FeedProvider>();

    final description = _descriptionController.text.trim();
    final type = _type.trim();
    final currentChaptersText = _currentChaptersController.text.trim();
    final currentChapters =
        currentChaptersText.isEmpty ? null : int.tryParse(currentChaptersText);
    final tagsRaw = _tagsController.text.trim();
    final tags = tagsRaw.isEmpty
        ? null
        : tagsRaw
            .split(',')
            .map((t) => t.trim())
            .where((t) => t.isNotEmpty)
            .toList();

    final ok = await provider.createPost(
      description: description,
      type: type,
      currentChapters: currentChapters,
      tags: tags,
      imagePath: _image?.path,
    );

    if (!context.mounted) return;

    if (ok) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Publicación creada'),
          backgroundColor: Colors.green,
        ),
      );
      navigator.pop();
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage),
          backgroundColor: theme.colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Post')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                maxLength: 2000,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  prefixIcon: Icon(Icons.description_outlined),
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return 'La descripción es obligatoria';
                  if (text.length > 2000) return 'Máximo 2000 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _type,
                items: const [
                  DropdownMenuItem(value: 'anime', child: Text('Anime')),
                  DropdownMenuItem(value: 'manga', child: Text('Manga')),
                  DropdownMenuItem(value: 'manhwa', child: Text('Manhwa')),
                ],
                onChanged: (v) => setState(() => _type = v ?? 'manga'),
                decoration: const InputDecoration(
                  labelText: 'Tipo',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                validator: (value) {
                  final v = value?.trim() ?? '';
                  if (v.isEmpty) return 'Selecciona el tipo';
                  if (!(v == 'anime' || v == 'manga' || v == 'manhwa')) {
                    return 'Tipo inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _currentChaptersController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Capítulos actuales (opcional)',
                  prefixIcon: Icon(Icons.numbers),
                ),
                validator: (value) {
                  final v = value?.trim() ?? '';
                  if (v.isEmpty) return null;
                  final n = int.tryParse(v);
                  if (n == null) return 'Debe ser un número';
                  if (n < 0) return 'Debe ser mayor o igual a 0';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: 'Tags separados por coma (opcional)',
                  prefixIcon: Icon(Icons.tag),
                ),
                validator: (value) {
                  final v = value?.trim() ?? '';
                  if (v.isEmpty) return null;
                  final tags = v
                      .split(',')
                      .map((t) => t.trim())
                      .where((t) => t.isNotEmpty)
                      .toList();
                  if (tags.length > 10) return 'Máximo 10 tags';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              if (_image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _image!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image_outlined),
                label: const Text('Seleccionar imagen (opcional)'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _submit(context),
                child: const Text('Crear'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
