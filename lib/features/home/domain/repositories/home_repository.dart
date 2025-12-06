import 'package:boilerplate/core/utils/typedef.dart';
import 'package:boilerplate/features/home/domain/entities/greeting.dart';

abstract class HomeRepository {
  FutureEither<Greeting> getGreeting();
}
