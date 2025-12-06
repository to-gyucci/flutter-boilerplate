import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:boilerplate/features/home/domain/entities/greeting.dart';

part 'home_state.freezed.dart';

@Freezed()
sealed class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.loading() = _Loading;
  const factory HomeState.loaded(Greeting greeting) = _Loaded;
  const factory HomeState.error(String message) = _Error;
}
