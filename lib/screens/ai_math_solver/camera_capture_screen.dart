import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/playful_background.dart';
import '../../core/theme/app_colors.dart';
import '../../services/audio/audio_manager.dart';
import 'solution_display_screen_v2.dart';

/// Camera capture screen for AI Math Solver
class CameraCaptureScreen extends StatefulWidget {
  const CameraCaptureScreen({super.key});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  /// Capture image from camera
  Future<void> _captureFromCamera() async {
    try {
      audioManager.playButtonClick();
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (photo != null) {
        setState(() {
          _imageFile = File(photo.path);
        });
      }
    } catch (e) {
      if (mounted) {
        _showError('ไม่สามารถเปิดกล้องได้: ${e.toString()}');
      }
    }
  }

  /// Pick image from gallery
  Future<void> _pickFromGallery() async {
    try {
      audioManager.playButtonClick();
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
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
    if (_imageFile == null) return;

    audioManager.playButtonClick();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SolutionDisplayScreenV2(imageFile: _imageFile!),
      ),
    );
  }

  /// Clear selected image
  void _clearImage() {
    audioManager.playButtonClick();
    setState(() {
      _imageFile = null;
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
            child: const Text('ตรงลง'),
          ),
        ],
      ),
    );
  }

  /// Show image source selection bottom sheet
  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),

            // Title
            Text(
              'เลือกแหล่งที่มารูปภาพ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 24),

            // Camera option
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.camera_alt, color: AppColors.primaryPurple),
              ),
              title: Text('ถ่ายภาพ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              subtitle: Text('เปิดกล้องถ่ายรูปโจทย์', style: TextStyle(fontSize: 14)),
              onTap: () {
                Navigator.pop(context);
                _captureFromCamera();
              },
            ),

            SizedBox(height: 8),

            // Gallery option
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.photo_library, color: AppColors.primaryBlue),
              ),
              title: Text('เลือกจากคลัง', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              subtitle: Text('เลือกรูปจากคลังรูปภาพ', style: TextStyle(fontSize: 14)),
              onTap: () {
                Navigator.pop(context);
                _pickFromGallery();
              },
            ),

            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If no image selected, show FAB interface
    if (_imageFile == null) {
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
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryPurple.withValues(alpha: 0.15),
                            blurRadius: 16,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        size: 56,
                        color: AppColors.primaryPurple,
                      ),
                    ),

                    SizedBox(height: 24),

                    // Title
                    Text(
                      'ถ่ายภาพโจทย์',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    SizedBox(height: 8),

                    // Subtitle
                    Text(
                      'ให้ AI ช่วยแก้โจทย์คณิตศาสตร์และฟิสิกส์',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    SizedBox(height: 40),

                    // Action Buttons (Horizontal)
                    Row(
                      children: [
                        // Camera Button
                        Expanded(
                          child: SizedBox(
                            height: 72,
                            child: ElevatedButton(
                              onPressed: _captureFromCamera,
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
                                children: [
                                  Icon(Icons.camera_alt, size: 28),
                                  SizedBox(height: 6),
                                  Text(
                                    'ถ่ายภาพ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 12),

                        // Gallery Button
                        Expanded(
                          child: SizedBox(
                            height: 72,
                            child: OutlinedButton(
                              onPressed: _pickFromGallery,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primaryBlue,
                                side: BorderSide(
                                  color: AppColors.primaryBlue,
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.photo_library, size: 28),
                                  SizedBox(height: 6),
                                  Text(
                                    'คลังรูป',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 32),

                    // Quick tips
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.tips_and_updates_outlined,
                            color: AppColors.primaryOrange, size: 20),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'ถ่ายรูปให้ชัด แสงเพียงพอ โจทย์อยู่กลางภาพ',
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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showImageSourceOptions,
          backgroundColor: AppColors.primaryPurple,
          icon: Icon(Icons.add_a_photo, color: Colors.white),
          label: Text('เลือกรูปภาพ', style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
          icon: Icon(Icons.close),
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
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        offset: Offset(0, 4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(
                      _imageFile!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // Action buttons
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Retake button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _clearImage,
                        icon: Icon(Icons.refresh),
                        label: Text('ถ่ายใหม่'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryOrange,
                          side: BorderSide(color: AppColors.primaryOrange),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 12),

                    // Confirm button
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: _confirmAndAnalyze,
                        icon: Icon(Icons.check_circle),
                        label: Text('วิเคราะห์โจทย์'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
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
