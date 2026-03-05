import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/playful_background.dart';
import '../../core/theme/app_colors.dart';
import '../../services/audio/audio_manager.dart';
import 'solution_display_screen_v2_web.dart';

/// Camera capture screen for AI Math Solver (Web version)
class CameraCaptureScreenWeb extends StatefulWidget {
  const CameraCaptureScreenWeb({super.key});

  @override
  State<CameraCaptureScreenWeb> createState() => _CameraCaptureScreenWebState();
}

class _CameraCaptureScreenWebState extends State<CameraCaptureScreenWeb> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  String? _imageName;

  /// Pick image from file (Web uses file picker instead of camera)
  Future<void> _pickImage() async {
    try {
      audioManager.playButtonClick();
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery, // Web will show file picker
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _imageName = image.name;
        });
      }
    } catch (e) {
      if (mounted) {
        _showError('ไม่สามารถเลือกรูปภาพได้: ${e.toString()}');
      }
    }
  }

  /// Confirm and send image to AI
  void _confirmAndAnalyze() {
    if (_imageBytes == null) return;

    audioManager.playButtonClick();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SolutionDisplayScreenV2Web(
          imageBytes: _imageBytes!,
          imageName: _imageName ?? 'image.jpg',
        ),
      ),
    );
  }

  /// Clear selected image
  void _clearImage() {
    audioManager.playButtonClick();
    setState(() {
      _imageBytes = null;
      _imageName = null;
    });
  }

  /// Show error dialog
  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('เกิดข้อผิดพลาด'),
        content: Text(message),
        actions: [
          TextButton(
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

  @override
  Widget build(BuildContext context) {
    // If no image selected, show initial UI
    if (_imageBytes == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('🤖 AI แก้โจทย์'),
          centerTitle: true,
          backgroundColor: AppColors.primaryPurple,
          foregroundColor: Colors.white,
        ),
        body: AnimatedPlayfulBackground(
          gradient: AppColors.sunnyBackground,
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryPurple.withValues(alpha: 0.15),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.photo_library_rounded,
                        size: 56,
                        color: AppColors.primaryPurple,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Title
                    Text(
                      'เลือกรูปภาพโจทย์',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      'ให้ AI ช่วยแก้โจทย์คณิตศาสตร์และฟิสิกส์',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Select Image Button
                    SizedBox(
                      width: double.infinity,
                      height: 72,
                      child: ElevatedButton(
                        onPressed: _pickImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.photo_library, size: 28),
                            SizedBox(height: 6),
                            Text(
                              'เลือกรูปภาพ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Quick tips
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.tips_and_updates_outlined,
                              color: AppColors.primaryOrange, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'เลือกรูปที่ชัด แสงเพียงพอ โจทย์อยู่กลางภาพ',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    // If image selected, show preview and confirm
    return Scaffold(
      appBar: AppBar(
        title: const Text('ตรวจสอบรูปภาพ'),
        centerTitle: true,
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _clearImage,
        ),
      ),
      body: AnimatedPlayfulBackground(
        gradient: AppColors.sunnyBackground,
        child: SafeArea(
          child: Column(
            children: [
              // Image preview
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        offset: const Offset(0, 4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.memory(
                      _imageBytes!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // Action buttons
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Retake button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _clearImage,
                        icon: const Icon(Icons.refresh),
                        label: const Text('เลือกใหม่'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryOrange,
                          side: BorderSide(color: AppColors.primaryOrange),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Confirm button
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: _confirmAndAnalyze,
                        icon: const Icon(Icons.check_circle),
                        label: const Text('วิเคราะห์โจทย์'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
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
}
