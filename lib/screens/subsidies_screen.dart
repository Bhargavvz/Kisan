import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_theme.dart';
import '../utils/app_localization.dart';
import '../models/government_subsidy.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/common_widgets.dart';
import '../services/government_subsidies_service.dart';
import '../utils/deprecation_fixes.dart';

class SubsidiesScreen extends StatefulWidget {
  const SubsidiesScreen({super.key});

  @override
  State<SubsidiesScreen> createState() => _SubsidiesScreenState();
}

class _SubsidiesScreenState extends State<SubsidiesScreen> {
  List<GovernmentSubsidy> _subsidies = [];
  bool _isLoading = false;
  Stream<List<GovernmentSubsidy>>? _subsidiesStream;
  final GovernmentSubsidiesService _subsidiesService =
      GovernmentSubsidiesService();

  @override
  void initState() {
    super.initState();
    _loadSubsidies();
  }

  void _loadSubsidies() {
    setState(() {
      _isLoading = true;
      _subsidiesStream = _subsidiesService.getSubsidies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          context.t('subsidies'),
          style: AppTextStyles.h3.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSubsidies,
          ),
        ],
      ),
      body: Column(
        children: [
          // Header section
          Container(
            color: AppColors.primary,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppBorderRadius.xl),
                  topRight: Radius.circular(AppBorderRadius.xl),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.t('availableSchemes'),
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Access government schemes and subsidies designed to support farmers',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Subsidies list
          Expanded(
            child: StreamBuilder<List<GovernmentSubsidy>>(
              stream: _subsidiesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    _isLoading) {
                  return const LoadingWidget(message: 'Loading subsidies...');
                }

                if (snapshot.hasError) {
                  return ErrorStateWidget(
                    message: 'Failed to load subsidies: ${snapshot.error}',
                    onRetry: _loadSubsidies,
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return EmptyStateWidget(
                    title: 'No subsidies available',
                    description: 'Check back later for new schemes',
                    icon: Icons.account_balance,
                  );
                }

                _subsidies = snapshot.data!;

                return RefreshIndicator(
                  onRefresh: () async {
                    _loadSubsidies();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: _subsidies.length,
                    itemBuilder: (context, index) {
                      return _buildSubsidyCard(_subsidies[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubsidyCard(GovernmentSubsidy subsidy) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: ExpandableCard(
        title: subsidy.schemeName,
        subtitle: subsidy.description,
        leadingIcon: Icons.account_balance,
        iconColor: AppColors.primary,
        expandedContent: _buildSubsidyDetails(subsidy),
      ),
    );
  }

  Widget _buildSubsidyDetails(GovernmentSubsidy subsidy) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Basic information
        Row(
          children: [
            Expanded(
              child: _buildInfoItem(
                'Category',
                subsidy.category,
                Icons.category,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildInfoItem(
                'Max Amount',
                subsidy.maxAmount > 0
                    ? '₹${subsidy.maxAmount.toStringAsFixed(0)}'
                    : 'N/A',
                Icons.currency_rupee,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        Row(
          children: [
            Expanded(
              child: _buildInfoItem(
                'Department',
                subsidy.department,
                Icons.business,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildInfoItem(
                'Deadline',
                '${subsidy.deadline.day}/${subsidy.deadline.month}/${subsidy.deadline.year}',
                Icons.calendar_today,
                textColor: subsidy.isDeadlineNear
                    ? AppColors.warning
                    : subsidy.isExpired
                        ? AppColors.error
                        : null,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),

        // Eligibility criteria
        Text(
          context.t('eligibilityCriteria'),
          style: AppTextStyles.h4.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ...subsidy.eligibilityCriteria.map((criteria) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 16,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      criteria,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            )),

        const SizedBox(height: AppSpacing.lg),

        // Required documents
        Text(
          'Required Documents',
          style: AppTextStyles.h4.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ...subsidy.requiredDocuments.map((document) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.description,
                    size: 16,
                    color: AppColors.info,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      document,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            )),

        const SizedBox(height: AppSpacing.lg),

        // Application process
        Text(
          context.t('howToApply'),
          style: AppTextStyles.h4.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          subsidy.applicationProcess,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // Contact information
        if (subsidy.contactNumber != null || subsidy.website != null) ...[
          Text(
            'Contact Information',
            style: AppTextStyles.h4.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (subsidy.contactNumber != null)
            Row(
              children: [
                const Icon(
                  Icons.phone,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  subsidy.contactNumber!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          if (subsidy.website != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const Icon(
                  Icons.web,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    subsidy.website!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
        ],

        // Apply button
        Row(
          children: [
            Expanded(
              child: CustomButton(
                text: context.t('apply'),
                onPressed: subsidy.isExpired
                    ? null
                    : () {
                        _showApplicationDialog(subsidy);
                      },
                backgroundColor:
                    subsidy.isExpired ? AppColors.textLight : AppColors.primary,
                icon: Icons.open_in_new,
              ),
            ),
            if (subsidy.isDeadlineNear) ...[
              const SizedBox(width: AppSpacing.md),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warning.withAlpha(
                      26), // Changed from withOpacity(0.1) to withAlpha(26)
                  borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Deadline Near',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildInfoItem(
    String label,
    String value,
    IconData icon, {
    Color? textColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: AppColors.textLight,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: textColor ?? AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _showApplicationDialog(GovernmentSubsidy subsidy) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Apply for ${subsidy.schemeName}',
          style: AppTextStyles.h4,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This will redirect you to the official application portal or provide contact information for applying.',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Application Process:',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              subsidy.applicationProcess,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.t('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // In a real app, this would open the application portal
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Redirecting to application portal...'),
                ),
              );
            },
            child: Text(context.t('apply')),
          ),
        ],
      ),
    );
  }
}
