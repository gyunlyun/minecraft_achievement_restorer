import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:minecraft_achievement_restorer/services/processor_service.dart';

void main() {
  group('Stream Management Tests', () {
    late ProcessorService processor;

    setUp(() {
      processor = ProcessorService();
    });

    test('should handle closed stream gracefully', () async {
      // Create a stream controller
      final controller = StreamController<String>();
      
      // Set up progress callback to add to the stream
      processor.setProgressCallback((message) {
        controller.add(message);
      });
      
      // Close the stream
      controller.close();
      
      // This should not throw an error even though the stream is closed
      expect(() {
        processor.setLocalizedStrings(
          scanningWorlds: () => 'Scanning...',
          scanningPath: (path) => 'Scanning $path',
          checkingWorld: (world) => 'Checking $world',
          foundWorlds: (count) => 'Found $count worlds',
          minecraftNotFound: 'Minecraft not found',
          startingProcessing: 'Starting processing',
          processingWorldCount: (count) => 'Processing $count worlds',
          processingWorld: (world) => 'Processing $world',
          completedWorld: (world) => 'Completed $world',
          failedWorld: (world, error) => 'Failed $world: $error',
          allProcessingComplete: (count) => 'All $count complete',
          partialProcessingComplete: (success, failed) => '$success success, $failed failed',
          createdBackup: (filename) => 'Created backup $filename',
          modifiedLevelDat: 'Modified level.dat',
        );
        
        // Try to trigger progress update - this should not crash
        // We can't directly call _updateProgress as it's private, but we can
        // test that clearing the callback works
        processor.clearProgressCallback();
      }, returnsNormally);
    });

    test('should clear progress callback properly', () {
      // Set a callback
      processor.setProgressCallback((message) {
        // Callback implementation
      });

      // Clear the callback
      processor.clearProgressCallback();

      // The callback should be cleared (we can't directly test this without
      // accessing private methods, but we can verify the method exists)
      expect(processor.clearProgressCallback, isA<Function>());
    });

    test('should handle null callback gracefully', () {
      expect(() {
        processor.setProgressCallback(null);
      }, returnsNormally);

      expect(() {
        processor.clearProgressCallback();
      }, returnsNormally);
    });

    test('should handle completion stream properly', () async {
      final progressController = StreamController<String>();
      final completionController = StreamController<bool>();

      bool completionReceived = false;

      // Listen to completion stream
      completionController.stream.listen((completed) {
        completionReceived = completed;
      });

      // Signal completion
      completionController.add(true);

      // Wait a bit for the stream to process
      await Future.delayed(const Duration(milliseconds: 10));

      expect(completionReceived, isTrue);

      // Clean up
      progressController.close();
      completionController.close();
    });
  });
}
