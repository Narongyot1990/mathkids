import 'dart:math';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../services/audio/audio_manager.dart';

/// Parental Gate Widget - ป้องกันไม่ให้เด็กเข้าถึงการตั้งค่าที่ต้องการผู้ใหญ่
/// 
/// ต้องแก้โจทย์คณิตศาสตร์ง่ายๆ ก่อนเข้าถึง
class ParentalGate extends StatefulWidget {
  /// Callback เมื่อผ่านการตรวจสอบแล้ว
  final VoidCallback onPassed;

  /// ข้อความที่แสดง (ภาษา)
  final String title;
  final String instruction;

  const ParentalGate({
    super.key,
    required this.onPassed,
    this.title = '🔒 สำหรับผู้ใหญ่',
    this.instruction = 'กรุณาตอบคำถามเพื่อดำเนินการต่อ',
  });

  @override
  State<ParentalGate> createState() => _ParentalGateState();
}

class _ParentalGateState extends State<ParentalGate> {
  late int _num1;
  late int _num2;
  late int _correctAnswer;
  final TextEditingController _answerController = TextEditingController();
  String? _errorMessage;
  int _attempts = 0;

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _generateQuestion() {
    final random = Random();
    // สร้างคำถามบวกเลขง่ายๆ (เหมาะสำหรับผู้ใหญ่แต่ยากสำหรับเด็ก)
    _num1 = random.nextInt(20) + 10; // 10-29
    _num2 = random.nextInt(15) + 5;  // 5-19
    _correctAnswer = _num1 + _num2;
  }

  void _checkAnswer() {
    final userAnswer = int.tryParse(_answerController.text);
    
    if (userAnswer == _correctAnswer) {
      audioManager.playButtonClick();
      widget.onPassed();
    } else {
      audioManager.playButtonClick();
      setState(() {
        _attempts++;
        _errorMessage = '❌ คำตอบไม่ถูกต้อง ลองอีกครั้ง';
        _answerController.clear();
        
        // สร้างคำถามใหม่หลังจากผิด
        _generateQuestion();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Lock Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock,
                size: 48,
                color: AppColors.primaryPurple,
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              widget.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),

            // Instruction
            Text(
              widget.instruction,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Math Question
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.backgroundSky,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$_num1 + $_num2 = ?',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
              ),
            ),
            const SizedBox(height: 16),

            // Answer Input
            TextField(
              controller: _answerController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
              decoration: InputDecoration(
                hintText: 'ใส่คำตอบ',
                errorText: _errorMessage,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primaryPurple,
                    width: 2,
                  ),
                ),
              ),
              onSubmitted: (_) => _checkAnswer(),
            ),
            const SizedBox(height: 20),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      audioManager.playButtonClick();
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('ยกเลิก'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _checkAnswer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('ตอบ'),
                  ),
                ),
              ],
            ),

            // Attempts info
            if (_attempts > 0)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'จำนวนครั้งที่ลอง: $_attempts',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Helper function to show parental gate
Future<bool> showParentalGate(BuildContext context) async {
  bool passed = false;
  
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => ParentalGate(
      onPassed: () {
        passed = true;
        Navigator.pop(context);
      },
    ),
  );
  
  return passed;
}
