import 'package:flutter/material.dart';
import '../../widgets/kid_button.dart';
import '../../widgets/playful_background.dart';
import '../../widgets/parental_gate.dart';
import '../../core/theme/app_colors.dart';
import '../../services/audio/audio_manager.dart';
import '../../services/progress_service.dart';
import 'privacy_policy_screen.dart';

/// Settings Screen - เมนูตั้งค่าความเป็นส่วนตัวและการจัดการข้อมูล
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedPlayfulBackground(
        gradient: AppColors.sunnyBackground,
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Back Button
                    KidButton(
                      text: '',
                      icon: Icons.arrow_back,
                      backgroundColor: AppColors.grey400,
                      onPressed: () {
                        audioManager.playButtonClick();
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 16),
                    // Title
                    Expanded(
                      child: Text(
                        '⚙️ ตั้งค่า',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),

              // Settings Options
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Privacy Section
                    _buildSectionTitle(context, '🔒 ความเป็นส่วนตัว'),
                    const SizedBox(height: 12),
                    
                    // Privacy Policy
                    _buildSettingsCard(
                      context,
                      icon: Icons.privacy_tip,
                      title: 'นโยบายความเป็นส่วนตัว',
                      subtitle: 'อ่านนโยบายความเป็นส่วนตัวของเรา',
                      color: AppColors.primaryPurple,
                      onTap: () {
                        audioManager.playButtonClick();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PrivacyPolicyScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Data Section
                    _buildSectionTitle(context, '📊 ข้อมูล'),
                    const SizedBox(height: 12),

                    // Delete Data (requires parental gate)
                    _buildSettingsCard(
                      context,
                      icon: Icons.delete_forever,
                      title: 'ลบข้อมูลทั้งหมด',
                      subtitle: 'ลบความคืบหน้าและสถิติทั้งหมด',
                      color: AppColors.error,
                      onTap: () async {
                        audioManager.playButtonClick();
                        // Show parental gate first
                        final passed = await showParentalGate(context);
                        if (passed && context.mounted) {
                          _showDeleteDataDialog(context);
                        }
                      },
                    ),

                    const SizedBox(height: 24),

                    // About Section
                    _buildSectionTitle(context, 'ℹ️ เกี่ยวกับ'),
                    const SizedBox(height: 12),

                    _buildSettingsCard(
                      context,
                      icon: Icons.info,
                      title: 'MathKids Adventure',
                      subtitle: 'เวอร์ชัน 1.0.0',
                      color: AppColors.primaryBlue,
                      onTap: () {
                        audioManager.playButtonClick();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              // Arrow
              Icon(
                Icons.chevron_right,
                color: AppColors.grey400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            const Icon(Icons.warning, color: AppColors.error),
            const SizedBox(width: 8),
            const Text('ลบข้อมูล?'),
          ],
        ),
        content: const Text(
          'การลบข้อมูลจะทำให้ความคืบหน้าและสถิติทั้งหมดหายไปอย่างถาวร\n\nคุณแน่ใจหรือไม่?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              audioManager.playButtonClick();
              Navigator.pop(dialogContext);
            },
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              audioManager.playButtonClick();
              
              // Delete all data using ProgressService
              final progressService = ProgressService();
              await progressService.resetAllProgress();
              
              if (dialogContext.mounted) {
                Navigator.pop(dialogContext);
              }
              
              // Show success dialog
              if (context.mounted) {
                _showDeleteSuccessDialog(context);
              }
            },
            child: const Text('ลบข้อมูล'),
          ),
        ],
      ),
    );
  }

  void _showDeleteSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.success),
            const SizedBox(width: 8),
            const Text('สำเร็จ!'),
          ],
        ),
        content: const Text(
          'ข้อมูลทั้งหมดถูกลบเรียบร้อยแล้ว',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              audioManager.playButtonClick();
              Navigator.pop(context);
            },
            child: const Text('ตกลง'),
          ),
        ],
      ),
    );
  }
}
