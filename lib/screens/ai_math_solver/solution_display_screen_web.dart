import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../widgets/playful_background.dart';
import '../../widgets/latex_markdown_viewer.dart';
import '../../core/theme/app_colors.dart';
import '../../services/audio/audio_manager.dart';
import '../../services/gemini_api_service_web.dart';

/// Solution display screen showing AI-generated math solution (Web version)
class SolutionDisplayScreenWeb extends StatefulWidget {
  final Uint8List imageBytes;
  final String imageName;

  const SolutionDisplayScreenWeb({
    super.key,
    required this.imageBytes,
    required this.imageName,
  });

  @override
  State<SolutionDisplayScreenWeb> createState() =>
      _SolutionDisplayScreenWebState();
}

class _SolutionDisplayScreenWebState extends State<SolutionDisplayScreenWeb> {
  final GeminiApiServiceWeb _geminiService = GeminiApiServiceWeb();
  bool _isLoading = true;
  String? _solution;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _analyzeMathProblem();
  }

  /// Send image to Gemini API for analysis
  Future<void> _analyzeMathProblem() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _geminiService.solveMathFromImageBytes(
        widget.imageBytes,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          if (response.success) {
            _solution = response.answer;
          } else {
            _errorMessage = response.error ?? 'เกิดข้อผิดพลาดที่ไม่ทราบสาเหตุ';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'เกิดข้อผิดพลาด: ${e.toString()}';
        });
      }
    }
  }

  /// Retry analysis
  void _retry() {
    audioManager.playButtonClick();
    _analyzeMathProblem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤖 AI แก้โจทย์'),
        centerTitle: true,
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
        actions: [
          if (_solution != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _retry,
              tooltip: 'วิเคราะห์ใหม่',
            ),
        ],
      ),
      body: AnimatedPlayfulBackground(
        gradient: AppColors.sunnyBackground,
        child: SafeArea(
          child: Column(
            children: [
              // Image preview (small)
              Container(
                height: 150,
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      offset: const Offset(0, 2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    widget.imageBytes,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Solution content
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        offset: const Offset(0, 2),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: _buildContent(),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// Build content based on state
  Widget _buildContent() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppColors.primaryPurple),
            ),
            const SizedBox(height: 24),
            Text(
              'กำลังวิเคราะห์โจทย์...',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'AI กำลังอ่านและแก้โจทย์\nอาจใช้เวลา 5-10 วินาที',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: AppColors.error,
            ),
            const SizedBox(height: 24),
            Text(
              'เกิดข้อผิดพลาด',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _retry,
              icon: const Icon(Icons.refresh),
              label: const Text('ลองใหม่'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_solution != null) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Success header
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  'คำตอบจาก AI',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: AppColors.grey300),
            const SizedBox(height: 16),

            // Solution content with LaTeX + Markdown
            LatexMarkdownViewer(
              data: _solution!,
            ),

            const SizedBox(height: 24),

            // Info note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.info.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.info,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'คำตอบนี้สร้างโดย AI อาจมีข้อผิดพลาด ควรตรวจสอบความถูกต้องอีกครั้ง',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.info,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
