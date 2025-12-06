import 'package:boilerplate/features/home/domain/entities/greeting.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Greeting Entity', () {
    test('should create a greeting with required fields', () {
      // Arrange
      const message = 'Hello World';
      const timestamp = '2025-12-06';

      // Act
      const greeting = Greeting(
        message: message,
        timestamp: timestamp,
      );

      // Assert
      expect(greeting.message, message);
      expect(greeting.timestamp, timestamp);
    });

    test('should support value equality', () {
      // Arrange
      const greeting1 = Greeting(
        message: 'Hello',
        timestamp: '2025-12-06',
      );
      const greeting2 = Greeting(
        message: 'Hello',
        timestamp: '2025-12-06',
      );

      // Assert
      expect(greeting1, greeting2);
    });

    test('should support copyWith', () {
      // Arrange
      const original = Greeting(
        message: 'Hello',
        timestamp: '2025-12-06',
      );

      // Act
      final updated = original.copyWith(message: 'Hi');

      // Assert
      expect(updated.message, 'Hi');
      expect(updated.timestamp, '2025-12-06');
    });
  });
}
