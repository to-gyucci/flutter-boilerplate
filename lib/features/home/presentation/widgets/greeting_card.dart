import 'package:flutter/material.dart';
import 'package:boilerplate/features/home/domain/entities/greeting.dart';

class GreetingCard extends StatelessWidget {
  final Greeting greeting;

  const GreetingCard({required this.greeting, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.waving_hand, size: 64, color: Colors.blue),
            const SizedBox(height: 16),
            Text(
              greeting.message,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Generated at: ${greeting.timestamp}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
