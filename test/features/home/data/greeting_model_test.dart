import 'package:boilerplate/features/home/data/models/greeting_model.dart';
import 'package:boilerplate/features/home/domain/entities/greeting.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GreetingModel', () {
    const tGreetingModel = GreetingModel(
      message: 'Test Message',
      timestamp: '2025-12-06T10:00:00Z',
    );

    test('should have same properties as Greeting entity', () {
      // Act
      final entity = tGreetingModel.toEntity();

      // Assert
      expect(entity.message, tGreetingModel.message);
      expect(entity.timestamp, tGreetingModel.timestamp);
    });

    group('fromJson', () {
      test('should return a valid model from JSON', () {
        // Arrange
        final Map<String, dynamic> jsonMap = {
          'message': 'Test Message',
          'timestamp': '2025-12-06T10:00:00Z',
        };

        // Act
        final result = GreetingModel.fromJson(jsonMap);

        // Assert
        expect(result, tGreetingModel);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        // Act
        final result = tGreetingModel.toJson();

        // Assert
        final expectedMap = {
          'message': 'Test Message',
          'timestamp': '2025-12-06T10:00:00Z',
        };
        expect(result, expectedMap);
      });
    });

    group('toEntity', () {
      test('should convert GreetingModel to Greeting entity', () {
        // Act
        final result = tGreetingModel.toEntity();

        // Assert
        expect(result, isA<Greeting>());
        expect(result.message, tGreetingModel.message);
        expect(result.timestamp, tGreetingModel.timestamp);
      });
    });
  });
}
