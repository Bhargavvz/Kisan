import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/localization_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_theme.dart';
import '../utils/app_localization.dart';
import '../widgets/custom_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _autoSyncEnabled = true;
  bool _offlineModeEnabled = false;
  String _dataUsage = 'Normal';
  String _cacheSize = '50 MB';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          context.t('settings'),
          style: AppTextStyles.h3.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
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
                      'App Settings',
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Customize your app experience',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Settings sections
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Appearance
                  _buildSectionHeader('Appearance'),
                  CustomCard(
                    child: Column(
                      children: [
                        _buildLanguageSetting(),
                        const Divider(),
                        _buildThemeSetting(),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Notifications
                  _buildSectionHeader('Notifications'),
                  CustomCard(
                    child: Column(
                      children: [
                        _buildSwitchTile(
                          'Push Notifications',
                          'Receive notifications for updates and alerts',
                          _notificationsEnabled,
                          (value) {
                            setState(() {
                              _notificationsEnabled = value;
                            });
                          },
                          Icons.notifications,
                        ),
                        const Divider(),
                        _buildSwitchTile(
                          'Auto Sync',
                          'Automatically sync data when connected',
                          _autoSyncEnabled,
                          (value) {
                            setState(() {
                              _autoSyncEnabled = value;
                            });
                          },
                          Icons.sync,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Data & Storage
                  _buildSectionHeader('Data & Storage'),
                  CustomCard(
                    child: Column(
                      children: [
                        _buildSwitchTile(
                          'Offline Mode',
                          'Enable offline functionality',
                          _offlineModeEnabled,
                          (value) {
                            setState(() {
                              _offlineModeEnabled = value;
                            });
                          },
                          Icons.offline_pin,
                        ),
                        const Divider(),
                        _buildSelectTile(
                          'Data Usage',
                          'Control data consumption',
                          _dataUsage,
                          ['Low', 'Normal', 'High'],
                          (value) {
                            setState(() {
                              _dataUsage = value;
                            });
                          },
                          Icons.data_usage,
                        ),
                        const Divider(),
                        _buildInfoTile(
                          'Cache Size',
                          _cacheSize,
                          Icons.storage,
                          onTap: () {
                            _showClearCacheDialog();
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Privacy & Security
                  _buildSectionHeader('Privacy & Security'),
                  CustomCard(
                    child: Column(
                      children: [
                        _buildActionTile(
                          'Privacy Policy',
                          'View our privacy policy',
                          Icons.privacy_tip,
                          () {
                            _showPrivacyPolicy();
                          },
                        ),
                        const Divider(),
                        _buildActionTile(
                          'Terms of Service',
                          'View terms and conditions',
                          Icons.description,
                          () {
                            _showTermsOfService();
                          },
                        ),
                        const Divider(),
                        _buildActionTile(
                          'Data Export',
                          'Export your data',
                          Icons.download,
                          () {
                            _showDataExportDialog();
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  // About
                  _buildSectionHeader('About'),
                  CustomCard(
                    child: Column(
                      children: [
                        _buildInfoTile(
                          'App Version',
                          '1.0.0 (Build 1)',
                          Icons.info,
                        ),
                        const Divider(),
                        _buildActionTile(
                          'Rate App',
                          'Rate us on the app store',
                          Icons.star,
                          () {
                            _rateApp();
                          },
                        ),
                        const Divider(),
                        _buildActionTile(
                          'Share App',
                          'Share with friends',
                          Icons.share,
                          () {
                            _shareApp();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Text(
        title,
        style: AppTextStyles.h4.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildLanguageSetting() {
    return Consumer<LocalizationProvider>(
      builder: (context, localizationProvider, child) {
        return ListTile(
          leading: const Icon(Icons.language, color: AppColors.primary),
          title: Text(
            context.t('language'),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: Text(
            localizationProvider.isEnglish ? 'English' : 'ಕನ್ನಡ',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          trailing: DropdownButton<String>(
            value: localizationProvider.locale.languageCode,
            underline: Container(),
            items: [
              DropdownMenuItem(
                value: 'en',
                child: Text(context.t('english')),
              ),
              DropdownMenuItem(
                value: 'kn',
                child: Text(context.t('kannada')),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                localizationProvider.setLocale(Locale(value));
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildThemeSetting() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return ListTile(
          leading: Icon(
            themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            color: AppColors.primary,
          ),
          title: Text(
            'Theme',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: Text(
            themeProvider.isDarkMode ? 'Dark' : 'Light',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          trailing: Switch(
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
            activeColor: AppColors.primary,
          ),
        );
      },
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  Widget _buildSelectTile(
    String title,
    String subtitle,
    String value,
    List<String> options,
    ValueChanged<String> onChanged,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: DropdownButton<String>(
        value: value,
        underline: Container(),
        items: options.map((option) {
          return DropdownMenuItem(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: (newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
      ),
    );
  }

  Widget _buildInfoTile(
    String title,
    String value,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: AppSpacing.sm),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textLight,
            ),
          ],
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.textLight,
      ),
      onTap: onTap,
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will clear all cached data. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.t('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _cacheSize = '0 MB';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared successfully')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'This is a placeholder for the privacy policy. In a real app, this would contain the full privacy policy text or navigate to a web view.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'This is a placeholder for the terms of service. In a real app, this would contain the full terms text or navigate to a web view.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDataExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text('Export your data to a file?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.t('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data export started...')),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _rateApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Redirecting to app store...')),
    );
  }

  void _shareApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing app...')),
    );
  }
}
