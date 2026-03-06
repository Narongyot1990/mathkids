import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mathkids_adventure/services/gemini_api_service_structured.dart';
import 'package:mathkids_adventure/models/solution_model.dart';

/// Test suite for AI Math Solver V2
///
/// This test suite validates:
/// - Gemini API integration
/// - JSON parsing
/// - LaTeX formatting
/// - Response structure
/// - Different problem types
///
/// NOTE: These tests require test images in assets/images/tests/
/// and a valid Gemini API key. They will be skipped if images are missing.
void main() {
  late GeminiApiServiceStructured service;

  setUpAll(() {
    service = GeminiApiServiceStructured();
  });

  group('AI Math Solver V2 - Real Image Tests', () {

    test('Test 1: Square Root Equation (√x-2 + 2 = √2x+3)', () async {
      final imageFile = File('assets/images/tests/test_1.png');
      // Skip test if image doesn't exist
      if (!imageFile.existsSync()) {
        print('⚠️ Test image not found, skipping test');
        return;
      }

      print('\n========================================');
      print('🧪 Test 1: Square Root Equation');
      print('========================================');

      final solution = await service.solveMathFromImage(imageFile);

      print('✅ API Response Received');
      print('📝 Problem: ${solution.problem}');
      print('📊 Type: ${solution.problemType}');
      print('💡 Summary: ${solution.summary}');
      print('🎯 Answer: ${solution.finalAnswer}');
      print('📋 Steps: ${solution.steps.length} steps');
      print('🌟 Encouragement: ${solution.encouragement}');

      // Assertions
      expect(solution.problem, isNotEmpty);
      expect(solution.problemType, isIn(['arithmetic', 'algebra', 'geometry', 'calculus']));
      expect(solution.summary, isNotEmpty);
      expect(solution.steps.length, greaterThan(0));
      expect(solution.steps.length, lessThanOrEqualTo(10)); // Complex problems may need more steps
      expect(solution.finalAnswer, isNotEmpty);
      expect(solution.encouragement, isNotEmpty);

      // Check LaTeX formatting
      for (var step in solution.steps) {
        expect(step.title, isNotEmpty);
        expect(step.explanation, isNotEmpty);
        if (step.calculation != null) {
          // Should contain $ delimiter
          expect(step.calculation, anyOf(contains(r'$'), contains(r'$$')));
        }
      }

      print('✅ All validations passed for Test 1\n');
    }, timeout: const Timeout(Duration(seconds: 60)));

    test('Test 2: Logarithm Problem', () async {
      final imageFile = File('assets/images/tests/test_2.png');
      if (!imageFile.existsSync()) {
        print('⚠️ Test image not found, skipping test');
        return;
      }

      print('\n========================================');
      print('🧪 Test 2: Logarithm Problem');
      print('========================================');

      final solution = await service.solveMathFromImage(imageFile);

      print('✅ API Response Received');
      print('📝 Problem: ${solution.problem}');
      print('📊 Type: ${solution.problemType}');
      print('💡 Summary: ${solution.summary}');
      print('🎯 Answer: ${solution.finalAnswer}');
      print('📋 Steps: ${solution.steps.length} steps');

      expect(solution.problem, contains('log'));
      expect(solution.steps.length, greaterThan(0));

      print('✅ All validations passed for Test 2\n');
    }, timeout: const Timeout(Duration(seconds: 60)));

    test('Test 3: Mixed Radicals (√147 - √(1/27) - ...)', () async {
      final imageFile = File('assets/images/tests/test_3.png');
      if (!imageFile.existsSync()) {
        print('⚠️ Test image not found, skipping test');
        return;
      }

      print('\n========================================');
      print('🧪 Test 3: Mixed Radicals');
      print('========================================');

      final solution = await service.solveMathFromImage(imageFile);

      print('✅ API Response Received');
      print('📝 Problem: ${solution.problem}');
      print('📊 Type: ${solution.problemType}');
      print('💡 Summary: ${solution.summary}');
      print('🎯 Answer: ${solution.finalAnswer}');
      print('📋 Steps: ${solution.steps.length} steps');

      expect(solution.problem, isNotEmpty);
      expect(solution.steps.length, greaterThan(0));

      print('✅ All validations passed for Test 3\n');
    }, timeout: const Timeout(Duration(seconds: 60)));

    test('Test 5: Radicals with Fractions', () async {
      final imageFile = File('assets/images/tests/test_5.png');
      if (!imageFile.existsSync()) {
        print('⚠️ Test image not found, skipping test');
        return;
      }

      print('\n========================================');
      print('🧪 Test 5: Radicals with Fractions');
      print('========================================');

      final solution = await service.solveMathFromImage(imageFile);

      print('✅ API Response Received');
      print('📝 Problem: ${solution.problem}');
      print('📊 Type: ${solution.problemType}');
      print('💡 Summary: ${solution.summary}');
      print('🎯 Answer: ${solution.finalAnswer}');
      print('📋 Steps: ${solution.steps.length} steps');

      expect(solution.problem, isNotEmpty);
      expect(solution.steps.length, greaterThan(0));

      print('✅ All validations passed for Test 5\n');
    }, timeout: const Timeout(Duration(seconds: 60)));

    test('Test 6: Simple Radicals (√18 + √8)', () async {
      final imageFile = File('assets/images/tests/test_6.png');
      if (!imageFile.existsSync()) {
        print('⚠️ Test image not found, skipping test');
        return;
      }

      print('\n========================================');
      print('🧪 Test 6: Simple Radicals');
      print('========================================');

      final solution = await service.solveMathFromImage(imageFile);

      print('✅ API Response Received');
      print('📝 Problem: ${solution.problem}');
      print('📊 Type: ${solution.problemType}');
      print('💡 Summary: ${solution.summary}');
      print('🎯 Answer: ${solution.finalAnswer}');
      print('📋 Steps: ${solution.steps.length} steps');

      // This should be simpler, fewer steps expected
      expect(solution.steps.length, lessThanOrEqualTo(5));

      print('✅ All validations passed for Test 6\n');
    }, timeout: const Timeout(Duration(seconds: 60)));

    test('Test 7: Negative Exponent ((-1/5)^-k = 25)', () async {
      final imageFile = File('assets/images/tests/test_7.png');
      if (!imageFile.existsSync()) {
        print('⚠️ Test image not found, skipping test');
        return;
      }

      print('\n========================================');
      print('🧪 Test 7: Negative Exponent');
      print('========================================');

      final solution = await service.solveMathFromImage(imageFile);

      print('✅ API Response Received');
      print('📝 Problem: ${solution.problem}');
      print('📊 Type: ${solution.problemType}');
      print('💡 Summary: ${solution.summary}');
      print('🎯 Answer: ${solution.finalAnswer}');
      print('📋 Steps: ${solution.steps.length} steps');

      expect(solution.problemType, 'algebra');
      expect(solution.steps.length, greaterThan(0));

      print('✅ All validations passed for Test 7\n');
    }, timeout: const Timeout(Duration(seconds: 60)));

  });

  group('JSON Structure Validation', () {
    test('MathSolution toJson/fromJson works correctly', () {
      final testSolution = MathSolution(
        problem: r'$x + 2 = 5$',
        problemType: 'algebra',
        summary: 'หาค่า x โดยย้ายตัวเลข',
        steps: [
          SolutionStep(
            title: 'ย้าย +2',
            explanation: 'เปลี่ยนเครื่องหมาย',
            calculation: r'$x = 5 - 2$',
          ),
        ],
        finalAnswer: r'$x = 3$',
        encouragement: 'เก่งมาก!',
      );

      // Test serialization
      final json = testSolution.toJson();
      expect(json['problem'], r'$x + 2 = 5$');
      expect(json['problemType'], 'algebra');
      expect(json['steps'], isList);

      // Test deserialization
      final restored = MathSolution.fromJson(json);
      expect(restored.problem, testSolution.problem);
      expect(restored.problemType, testSolution.problemType);
      expect(restored.steps.length, testSolution.steps.length);

      print('✅ JSON serialization test passed');
    });
  });

  group('Problem Type Helper', () {
    test('ProblemType.getDisplayName returns Thai names', () {
      expect(ProblemType.getDisplayName('arithmetic'), 'เลขคณิต');
      expect(ProblemType.getDisplayName('algebra'), 'พีชคณิต');
      expect(ProblemType.getDisplayName('geometry'), 'เรขาคณิต');
      expect(ProblemType.getDisplayName('calculus'), 'แคลคูลัส');
      expect(ProblemType.getDisplayName('unknown'), 'ทั่วไป');

      print('✅ Display name test passed');
    });

    test('ProblemType.getEmoji returns correct emojis', () {
      expect(ProblemType.getEmoji('arithmetic'), '🔢');
      expect(ProblemType.getEmoji('algebra'), '📐');
      expect(ProblemType.getEmoji('geometry'), '📏');
      expect(ProblemType.getEmoji('calculus'), '∫');

      print('✅ Emoji test passed');
    });
  });
}
