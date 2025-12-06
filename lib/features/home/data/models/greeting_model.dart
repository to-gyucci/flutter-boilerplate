import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:boilerplate/features/home/domain/entities/greeting.dart';

part 'greeting_model.freezed.dart';
part 'greeting_model.g.dart';

@freezed
abstract class GreetingModel with _$GreetingModel {
  const GreetingModel._();

  const factory GreetingModel({
    required String message,
    required String timestamp,
  }) = _GreetingModel;

  factory GreetingModel.fromJson(Map<String, dynamic> json) =>
      _$GreetingModelFromJson(json);

  Greeting toEntity() {
    return Greeting(message: message, timestamp: timestamp);
  }
}
