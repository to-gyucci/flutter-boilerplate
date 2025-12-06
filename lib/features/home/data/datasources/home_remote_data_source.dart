import 'package:boilerplate/features/home/data/models/greeting_model.dart';

abstract class HomeRemoteDataSource {
  Future<GreetingModel> getGreeting();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  @override
  Future<GreetingModel> getGreeting() async {
    // 실제로는 API 호출
    await Future<void>.delayed(const Duration(seconds: 1));

    return GreetingModel(
      message: 'Hello, World from Clean Architecture!',
      timestamp: DateTime.now().toIso8601String(),
    );
  }
}
