import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/game_provider.dart';
import 'screens/main_menu/main_menu_screen.dart';
import 'services/audio/audio_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialize AudioManager
  await audioManager.initialize();

  runApp(const MathKidsApp());
}

class MathKidsApp extends StatefulWidget {
  const MathKidsApp({super.key});

  @override
  State<MathKidsApp> createState() => _MathKidsAppState();
}

class _MathKidsAppState extends State<MathKidsApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // เพิ่ม observer เพื่อฟัง app lifecycle
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // ลบ observer เมื่อ dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // จัดการเสียงตาม app state
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        // แอพถูก minimize หรือปิดหน้าจอ - พักเพลง
        audioManager.pauseMusic();
        break;
      case AppLifecycleState.resumed:
        // แอพกลับมา - เล่นเพลงต่อ
        audioManager.resumeMusic();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
      ],
      child: MaterialApp(
        title: 'MathKids Adventure',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainMenuScreen(),
      ),
    );
  }
}
