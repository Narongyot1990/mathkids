import 'package:flutter/material.dart';
import '../../widgets/kid_button.dart';
import '../../widgets/playful_background.dart';
import '../level_select/level_select_screen.dart';
import '../ai_math_solver/ai_math_solver_screen.dart';
import '../settings/settings_screen.dart';
import '../../services/audio/audio_manager.dart';
import '../../services/audio/audio_context.dart';
import '../../core/theme/app_colors.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  @override
  void initState() {
    super.initState();
    // เล่นเพลงเมนูเมื่อเข้าหน้า (Mobile: เล่นทันที, Web: รอ user interaction)
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        // พยายามเล่นเพลง - Mobile จะเล่นได้ทันที, Web จะ fail แต่ไม่เป็นไร
        // เพลงจะเล่นตอนคลิกปุ่มใดก็ได้ใน Web
        try {
          await audioManager.setContext(AudioContext.mainMenu);
        } catch (e) {
          // Web จะ fail ที่นี่ แต่เมื่อคลิกปุ่มครั้งแรกจะเล่นได้
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedPlayfulBackground(
        gradient: AppColors.sunnyBackground,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Emoji Icon with shadow
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.3),
                        offset: const Offset(-3, -3),
                        blurRadius: 8,
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        offset: const Offset(4, 4),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: const Text(
                    '🎮',
                    style: TextStyle(fontSize: 80),
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  'MathKids',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                Text(
                  'Adventure',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),

                const SizedBox(height: 60),

                // Play Button
                KidButton(
                  text: 'เล่นเกม',
                  icon: Icons.play_arrow,
                  onPressed: () async {
                    audioManager.playButtonClick();
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LevelSelectScreen(),
                      ),
                    );
                    if (mounted) {
                      setState(() {});
                    }
                  },
                ),

                const SizedBox(height: 20),

                // AI Math Solver Button
                KidButton(
                  text: '🤖 AI แก้โจทย์',
                  icon: Icons.camera_alt,
                  backgroundColor: AppColors.primaryPurple,
                  onPressed: () {
                    audioManager.playButtonClick();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AIMathSolverScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Settings Button
                KidButton(
                  text: 'ตั้งค่า',
                  icon: Icons.settings,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  onPressed: () async {
                    audioManager.playButtonClick();
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SettingsScreen(),
                      ),
                    );
                    if (mounted) {
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
