import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/solution_model.dart';
import '../../services/audio/audio_manager.dart';
import '../../services/gemini_api_service_structured.dart';
import '../../widgets/latex_markdown_viewer.dart';
import '../../widgets/playful_background.dart';

/// Solution Display Screen V2 with Progressive Disclosure UI
/// Based on educational best practices from Khan Academy, Photomath, and Microsoft Math
class SolutionDisplayScreenV2 extends StatefulWidget {
  final File imageFile;

  const SolutionDisplayScreenV2({
    super.key,
    required this.imageFile,
  });

  @override
  State<SolutionDisplayScreenV2> createState() => _SolutionDisplayScreenV2State();
}

class _SolutionDisplayScreenV2State extends State<SolutionDisplayScreenV2> {
  final _geminiService = GeminiApiServiceStructured();

  MathSolution? _solution;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _analyzeProblem();
  }

  /// Analyze problem using Gemini API
  Future<void> _analyzeProblem() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final solution = await _geminiService.solveMathFromImage(widget.imageFile);

      if (mounted) {
        setState(() {
          _solution = solution;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      }
    }
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
          if (!_isLoading && _solution != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                audioManager.playButtonClick();
                _analyzeProblem();
              },
              tooltip: 'วิเคราะห์ใหม่',
            ),
        ],
      ),
      body: AnimatedPlayfulBackground(
        gradient: AppColors.sunnyBackground,
        child: SafeArea(
          child: _isLoading
              ? _buildLoadingState()
              : _errorMessage != null
                  ? _buildErrorState()
                  : _buildSolutionContent(),
        ),
      ),
    );
  }

  /// Loading state with animation
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: AppColors.primaryPurple,
            strokeWidth: 3,
          ),
          const SizedBox(height: 24),
          Text(
            'AI กำลังวิเคราะห์โจทย์...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'กรุณารอสักครู่',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Error state with retry button
  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 24),
            Text(
              'เกิดข้อผิดพลาด',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _errorMessage ?? 'ไม่สามารถวิเคราะห์โจทย์ได้',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                audioManager.playButtonClick();
                _analyzeProblem();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('ลองอีกครั้ง'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Main solution content with progressive disclosure
  Widget _buildSolutionContent() {
    if (_solution == null) return const SizedBox.shrink();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1. Image Preview (small)
        _buildImagePreview(),
        const SizedBox(height: 16),

        // 2. Problem Card
        _buildProblemCard(),
        const SizedBox(height: 16),

        // 3. Summary Card (Always visible - most important)
        _buildSummaryCard(),
        const SizedBox(height: 16),

        // 4. Final Answer (Prominent - second most important)
        _buildFinalAnswerCard(),
        const SizedBox(height: 16),

        // 5. Steps Section (Expandable - details on demand)
        _buildStepsSection(),
        const SizedBox(height: 16),

        // 6. Encouragement
        _buildEncouragementCard(),

        const SizedBox(height: 32),
      ],
    );
  }

  /// Image preview widget
  Widget _buildImagePreview() {
    return Container(
      height: 120,
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
        child: Image.file(
          widget.imageFile,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  /// Problem card widget
  Widget _buildProblemCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  ProblemType.getEmoji(_solution!.problemType),
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 8),
                Text(
                  'โจทย์',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryPurple,
                  ),
                ),
                const Spacer(),
                Chip(
                  label: Text(
                    ProblemType.getDisplayName(_solution!.problemType),
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.2),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LatexMarkdownViewer(data: _solution!.problem),
          ],
        ),
      ),
    );
  }

  /// Summary card widget (most important - always visible)
  Widget _buildSummaryCard() {
    return Card(
      elevation: 3,
      color: AppColors.primaryGreen.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.primaryGreen.withValues(alpha: 0.4),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb,
                  color: AppColors.primaryGreen,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'วิธีทำโดยสรุป',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _solution!.summary,
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Final answer card widget (prominent display)
  Widget _buildFinalAnswerCard() {
    return Card(
      elevation: 4,
      color: AppColors.primaryOrange.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.primaryOrange,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  'คำตอบ',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryOrange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: LatexMarkdownViewer(
                  data: _solution!.finalAnswer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Steps section with expandable cards (Progressive Disclosure)
  Widget _buildStepsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Row(
            children: [
              Icon(
                Icons.format_list_numbered,
                color: AppColors.primaryPurple,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'ทำทีละขั้นตอน',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        ..._solution!.steps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          return _buildStepCard(index, step);
        }),
      ],
    );
  }

  /// Individual step card (expandable)
  Widget _buildStepCard(int index, SolutionStep step) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          initiallyExpanded: index == 0, // First step open by default
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: CircleAvatar(
            backgroundColor: AppColors.primaryPurple.withValues(alpha: 0.2),
            child: Text(
              '${index + 1}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryPurple,
                fontSize: 16,
              ),
            ),
          ),
          title: Text(
            step.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryPurple,
            ),
          ),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Explanation
                Text(
                  step.explanation,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),

                // Calculation (if available)
                if (step.calculation != null && step.calculation!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.primaryPurple.withValues(alpha: 0.2),
                      ),
                    ),
                    child: LatexMarkdownViewer(
                      data: step.calculation!,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Encouragement card widget
  Widget _buildEncouragementCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryPurple.withValues(alpha: 0.1),
            AppColors.primaryBlue.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Text(
            '🌟',
            style: TextStyle(fontSize: 32),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _solution!.encouragement,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
