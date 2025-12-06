import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:boilerplate/features/home/presentation/pages/home_page.dart';
import 'package:boilerplate/routing/routes.dart';

/// GoRouter Provider - 앱의 라우팅 설정을 관리
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true, // 개발 중 라우팅 로그 확인
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.homeName,
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
      ),

      // 추가 라우트는 여기에 정의
      // GoRoute(
      //   path: AppRoutes.settings,
      //   name: AppRoutes.settingsName,
      //   builder: (context, state) => const SettingsPage(),
      // ),
    ],

    // 에러 페이지 (404 등)
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('페이지를 찾을 수 없습니다: ${state.uri}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('홈으로 돌아가기'),
            ),
          ],
        ),
      ),
    ),
  );
});

/// GoRouter 확장 메서드들 - 타입 안전한 네비게이션
extension RouterExtension on BuildContext {
  /// 타입 안전하게 홈으로 이동
  void goToHome() => go(AppRoutes.home);

  // TODO: 설정 페이지와 프로필 페이지 구현 후 추가
  // void goToSettings() => go(AppRoutes.settings);
  // void goToProfile() => go(AppRoutes.profile);
}
