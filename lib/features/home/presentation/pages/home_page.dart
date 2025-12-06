import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:boilerplate/features/home/presentation/providers/home_provider.dart';
import 'package:boilerplate/features/home/presentation/providers/home_state.dart';
import 'package:boilerplate/features/home/presentation/widgets/greeting_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Riverpod 3.0 Clean Architecture')),
      body: Center(
        child: homeState.when(
          initial: () => const Text('Press the button to load greeting'),
          loading: () => const CircularProgressIndicator(),
          loaded: (greeting) => GreetingCard(greeting: greeting),
          error: (message) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ref.read(homeProvider.notifier).loadGreeting();
        },
        icon: const Icon(Icons.refresh),
        label: const Text('Load Greeting'),
      ),
    );
  }
}
