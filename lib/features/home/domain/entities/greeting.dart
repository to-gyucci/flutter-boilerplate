import 'package:freezed_annotation/freezed_annotation.dart';

part 'greeting.freezed.dart';

@freezed
abstract class Greeting with _$Greeting {
  const Greeting._();

  const factory Greeting({
    required String message,
    required String timestamp,
  }) = _Greeting;
}
