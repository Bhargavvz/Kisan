import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../utils/app_colors.dart';
import '../utils/app_theme.dart';
import '../utils/app_localization.dart';
import '../utils/mock_data.dart';
import '../models/crop_diagnosis.dart';
import '../services/crop_diagnosis_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_card.dart';
import '../widgets/common_widgets.dart';
import '../utils/deprecation_fixes.dart';

class CropDiagnosisScreen extends StatefulWidget {
  const CropDiagnosisScreen({super.key});

  @override
  State<CropDiagnosisScreen> createState() => _CropDiagnosisScreenState();
}

class _CropDiagnosisScreenState extends State<CropDiagnosisScreen> {
  final ImagePicker _picker = ImagePicker();
  final CropDiagnosisService _diagnosisService = CropDiagnosisService();
  File? _selectedImage;
  CropDiagnosis? _diagnosis;
  bool _isLoading = false;
  List<CropDiagnosis> _diagnosisHistory = [];

  @override
  void initState() {
    super.initState();
    _loadDiagnosisHistory();
  }

  void _loadDiagnosisHistory() async {
    try {
      // In a real app, you would get the current user ID from auth service
      // For now, use a mock user ID
      const String mockUserId = 'mock_user_id';
      final history = await _diagnosisService.getUserDiagnoses(mockUserId);
      setState(() {
        _diagnosisHistory = history;
      });
    } catch (e) {
      // Fall back to mock data if service fails
      setState(() {
        _diagnosisHistory = MockData.getDiagnosisHistory();
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 600,
      );

      if (image != null && mounted) {
        setState(() {
          _selectedImage = File(image.path);
          _diagnosis = null;
        });
        _diagnosePlant();
      }
    } catch (e) {
      if (!mounted) return; // Check if widget is still mounted

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _diagnosePlant() async {
    if (_selectedImage == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 3));

      if (!mounted) return;

      // Mock diagnosis result
      final mockDiagnosis = CropDiagnosis(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'current_user_id', // This would be replaced with actual user ID
        cropType: 'Tomato',
        description: 'Tomato plant showing spots on leaves',
        imageUrl: _selectedImage!.path,
        location: 'Current Location',
        status: DiagnosisStatus.completed,
        submittedAt: DateTime.now(),
        completedAt: DateTime.now(),
        diagnosisResult: DiagnosisResult(
          disease: 'Late Blight',
          confidence: 0.87,
          description:
              'A fungal disease that affects tomato leaves and fruits, causing brown spots and wilting.',
          treatment: [
            'Remove affected leaves immediately',
            'Apply copper-based fungicide',
            'Improve air circulation around plants',
            'Reduce watering frequency',
          ],
          prevention: [
            'Plant disease-resistant varieties',
            'Ensure proper spacing between plants',
            'Avoid overhead watering',
            'Apply preventive fungicide spray',
          ],
          severity: DiseaseSeverity.moderate,
        ),
      );

      if (!mounted) return;

      setState(() {
        _diagnosis = mockDiagnosis;
        _diagnosisHistory.insert(0, mockDiagnosis);
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Diagnosis failed: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppBorderRadius.lg),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderMedium,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Select Image Source',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: _buildImageSourceOption(
                      icon: Icons.camera_alt,
                      title: context.t('takePicture'),
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildImageSourceOption(
                      icon: Icons.photo_library,
                      title: context.t('chooseFromGallery'),
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return CustomCard(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacitySafe(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 30,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          context.t('cropDiagnosis'),
          style: AppTextStyles.h3.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image selection section
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(AppSpacing.lg),
              child: CustomCard(
                child: Column(
                  children: [
                    if (_selectedImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        child: Image.file(
                          _selectedImage!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: AppColors.borderLight,
                          borderRadius:
                              BorderRadius.circular(AppBorderRadius.md),
                          border: Border.all(
                            color: AppColors.borderMedium,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 48,
                              color: AppColors.textLight,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Select an image to diagnose',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: AppSpacing.md),
                    CustomButton(
                      text: _selectedImage == null
                          ? 'Select Image'
                          : 'Change Image',
                      onPressed: _showImageSourceDialog,
                      icon: Icons.photo_camera,
                      isOutlined: _selectedImage != null,
                    ),
                    if (_selectedImage != null && !_isLoading) ...[
                      const SizedBox(height: AppSpacing.md),
                      CustomButton(
                        text: context.t('diagnoseNow'),
                        onPressed: _diagnosePlant,
                        icon: Icons.search,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Loading state
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: LoadingWidget(
                  message: 'Analyzing your crop image...',
                ),
              ),

            // Diagnosis result
            if (_diagnosis != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: _buildDiagnosisResult(_diagnosis!),
              ),

            // Diagnosis history
            if (_diagnosisHistory.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Text(
                      'Diagnosis History',
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_diagnosisHistory.length} items',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              ...(_diagnosisHistory.take(3).map((diagnosis) => Container(
                    margin: const EdgeInsets.only(
                      left: AppSpacing.lg,
                      right: AppSpacing.lg,
                      bottom: AppSpacing.md,
                    ),
                    child: _buildDiagnosisHistoryItem(diagnosis),
                  ))),
              if (_diagnosisHistory.length > 3)
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: TextButton(
                    onPressed: () {
                      // Navigate to full history
                    },
                    child: Text(
                      'View All History',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
            ],

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosisResult(CropDiagnosis diagnosis) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Result header
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: diagnosis.isHealthy
                      ? AppColors.success.withOpacitySafe(0.1)
                      : AppColors.error.withOpacitySafe(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  diagnosis.isHealthy ? Icons.eco : Icons.warning,
                  color:
                      diagnosis.isHealthy ? AppColors.success : AppColors.error,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      diagnosis.isHealthy
                          ? context.t('healthyPlant')
                          : context.t('diseaseDetected'),
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (diagnosis.hasDiagnosis)
                      Text(
                        diagnosis.diagnosisResult!.disease,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              if (diagnosis.hasDiagnosis)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacitySafe(0.1),
                    borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                  ),
                  child: Text(
                    '${(diagnosis.diagnosisResult!.confidence * 100).toInt()}%',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),

          if (diagnosis.hasDiagnosis) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              diagnosis.diagnosisResult!.description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],

          if (diagnosis.hasDiagnosis &&
              diagnosis.diagnosisResult!.treatment.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              context.t('treatment'),
              style: AppTextStyles.h4.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...diagnosis.diagnosisResult!.treatment.map((treatment) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.circle,
                        size: 8,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          treatment,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],

          if (diagnosis.hasDiagnosis &&
              diagnosis.diagnosisResult!.prevention.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              context.t('prevention'),
              style: AppTextStyles.h4.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...diagnosis.diagnosisResult!.prevention
                .map((prevention) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 8,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              prevention,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
          ],
        ],
      ),
    );
  }

  Widget _buildDiagnosisHistoryItem(CropDiagnosis diagnosis) {
    return CustomCard(
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              borderRadius: BorderRadius.circular(AppBorderRadius.sm),
            ),
            child: Icon(
              diagnosis.isHealthy ? Icons.eco : Icons.warning,
              color: diagnosis.isHealthy ? AppColors.success : AppColors.error,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  diagnosis.cropType,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  diagnosis.isHealthy
                      ? context.t('healthyPlant')
                      : diagnosis.hasDiagnosis
                          ? diagnosis.diagnosisResult!.disease
                          : context.t('diseaseDetected'),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${diagnosis.submittedAt.day}/${diagnosis.submittedAt.month}/${diagnosis.submittedAt.year}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
          if (diagnosis.hasDiagnosis)
            Text(
              '${(diagnosis.diagnosisResult!.confidence * 100).toInt()}%',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}
