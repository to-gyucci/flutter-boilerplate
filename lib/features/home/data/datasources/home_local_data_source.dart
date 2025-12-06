import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:boilerplate/features/home/data/models/greeting_model.dart';

abstract class HomeLocalDataSource {
  Future<GreetingModel?> getCachedGreeting();
  Future<void> cacheGreeting(GreetingModel greeting);
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const cachedGreetingKey = 'CACHED_GREETING';

  HomeLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<GreetingModel?> getCachedGreeting() async {
    final jsonString = sharedPreferences.getString(cachedGreetingKey);
    if (jsonString != null) {
      return GreetingModel.fromJson(
        json.decode(jsonString) as Map<String, dynamic>,
      );
    }
    return null;
  }

  @override
  Future<void> cacheGreeting(GreetingModel greeting) async {
    await sharedPreferences.setString(
      cachedGreetingKey,
      json.encode(greeting.toJson()),
    );
  }
}
