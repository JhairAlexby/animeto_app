import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animeto_app/features/feed/presentation/providers/feed_provider.dart';
import 'package:animeto_app/features/feed/presentation/widgets/publication_card.dart';

class HomeScreen extends StatefulWidget {
  static const String route = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeedProvider>().fetchPublications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animeto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<FeedProvider>(
        builder: (context, provider, child) {
          if (provider.state == FeedState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.state == FeedState.error) {
            return Center(child: Text(provider.errorMessage));
          }

          if (provider.state == FeedState.loaded) {
            return RefreshIndicator(
              onRefresh: () => provider.fetchPublications(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: provider.publications.length,
                itemBuilder: (context, index) {
                  final publication = provider.publications[index];
                  return PublicationCard(publication: publication);
                },
              ),
            );
          }

          return const Center(child: Text('Iniciando...'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}