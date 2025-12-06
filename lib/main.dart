import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:boilerplate/core/theme/app_theme.dart';
import 'package:boilerplate/features/home/presentation/providers/home_provider.dart';
import 'package:boilerplate/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SharedPreferences를 미리 초기화하여 requireValue 사용 안전성 확보
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Flutter Clean Architecture Boilerplate',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
