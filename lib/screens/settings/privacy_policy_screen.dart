import 'package:flutter/material.dart';
import '../../widgets/kid_button.dart';
import '../../widgets/playful_background.dart';
import '../../core/theme/app_colors.dart';
import '../../services/audio/audio_manager.dart';

/// Privacy Policy Screen - แสดงนโยบายความเป็นส่วนตัว
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedPlayfulBackground(
        gradient: AppColors.rainbowBackground,
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
                        '🔒 นโยบายความเป็นส่วนตัว',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),

              // Privacy Policy Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Center(
                            child: Text(
                              'นโยบายความเป็นส่วนตัว',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryPurple,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: Text(
                              'MathKids Adventure',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ),
                          const Divider(height: 32),

                          // Last Updated
                          _buildLastUpdated(context),
                          const SizedBox(height: 20),

                          // Introduction
                          _buildSection(
                            context,
                            title: '📝 บทนำ',
                            content:
                                'เรา MathKids Adventure ให้ความสำคัญกับความเป็นส่วนตัวของผู้ใช้งานโดยเฉพาะเด็กๆ นโยบายความเป็นส่วนตัวนี้จะอธิบายว่าเราเก็บรวบรวม ใช้ และปกป้องข้อมูลอย่างไร',
                          ),

                          // Data Collection
                          _buildSection(
                            context,
                            title: '📊 ข้อมูลที่เราเก็บรวบรวม',
                            content: '''• ข้อมูลความคืบหน้าในเกม (ด่านที่เล่น คะแนน ดาว)
• สถิติการเล่นเกม (จำนวนเกมที่เล่น เวลาที่เล่น)
• ข้อมูลการตั้งค่าเสียง
• ไม่มีการเก็บข้อมูลส่วนบุคคล เช่น ชื่อ อีเมล หรือที่อยู่''',
                          ),

                          // How We Use Data
                          _buildSection(
                            context,
                            title: '🎮 วิธีใช้ข้อมูล',
                            content: '''• เพื่อบันทึกความคืบหน้าในเกมของเด็ก
• เพื่อแสดงสถิติและความสำเร็จ
• เพื่อปรับปรุงประสบการณ์การเล่นเกม
• ไม่มีการแชร์ข้อมูลกับบุคคลที่สาม''',
                          ),

                          // Data Storage
                          _buildSection(
                            context,
                            title: '💾 การจัดเก็บข้อมูล',
                            content:
                                'ข้อมูลทั้งหมดถูกจัดเก็บไว้ในอุปกรณ์ของคุณเท่านั้น เราไม่มีเซิร์ฟเวอร์เก็บข้อมูล หากคุณต้องการลบข้อมูล สามารถทำได้ที่เมนู "ตั้งค่า" > "ลบข้อมูลทั้งหมด"',
                          ),

                          // Children's Privacy
                          _buildSection(
                            context,
                            title: '👶 ความเป็นส่วนตัวของเด็ก',
                            content:
                                'MathKids Adventure ออกแบบมาสำหรับเด็กอายุ 3-6 ปี เราไม่เก็บข้อมูลส่วนบุคคลใดๆ จากเด็ก และไม่มีการเก็บข้อมูลเพื่อการตลาดหรือโฆษณา',
                          ),

                          // Contact
                          _buildSection(
                            context,
                            title: '📧 ติดต่อเรา',
                            content:
                                'หากคุณมีคำถามเกี่ยวกับนโยบายความเป็นส่วนตัวนี้ กรุณาติดต่อเราผ่านทาง GitHub: github.com/Narongyot1990/mathkids',
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLastUpdated(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryMint.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.update, size: 16, color: AppColors.primaryGreen),
          const SizedBox(width: 6),
          Text(
            'อัปเดตล่าสุด: 6 มีนาคม 2026',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}
