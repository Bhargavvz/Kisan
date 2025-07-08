import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_theme.dart';
import '../utils/app_localization.dart';
import '../utils/mock_data.dart';
import '../models/crop_price.dart';
import '../widgets/custom_card.dart';
import '../widgets/common_widgets.dart';

class MarketPricesScreen extends StatefulWidget {
  const MarketPricesScreen({super.key});

  @override
  State<MarketPricesScreen> createState() => _MarketPricesScreenState();
}

class _MarketPricesScreenState extends State<MarketPricesScreen> {
  List<CropPrice> _cropPrices = [];
  List<CropPrice> _filteredPrices = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = false;

  final List<String> _categories = [
    'All',
    'Vegetables',
    'Fruits',
    'Grains',
  ];

  @override
  void initState() {
    super.initState();
    _loadCropPrices();
  }

  void _loadCropPrices() {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _cropPrices = MockData.getCropPrices();
          _filteredPrices = _cropPrices;
          _isLoading = false;
        });
      }
    });
  }

  void _filterPrices() {
    setState(() {
      _filteredPrices = _cropPrices.where((price) {
        final categoryMatch = _selectedCategory == 'All' || 
                             price.category == _selectedCategory;
        final searchMatch = _searchQuery.isEmpty ||
                           price.cropName.toLowerCase().contains(_searchQuery.toLowerCase());
        return categoryMatch && searchMatch;
      }).toList();
    });
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterPrices();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _filterPrices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          context.t('marketPrices'),
          style: AppTextStyles.h3.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCropPrices,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and filter section
          Container(
            color: AppColors.primary,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppBorderRadius.xl),
                  topRight: Radius.circular(AppBorderRadius.xl),
                ),
              ),
              child: Column(
                children: [
                  // Search bar
                  TextField(
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: context.t('search'),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _onSearchChanged('');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  
                  // Category filter
                  Row(
                    children: [
                      Text(
                        context.t('filter'),
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _categories.map((category) {
                              final isSelected = _selectedCategory == category;
                              return Container(
                                margin: const EdgeInsets.only(right: AppSpacing.sm),
                                child: FilterChip(
                                  label: Text(
                                    category == 'All' ? context.t('allCrops') : context.t(category.toLowerCase()),
                                  ),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    if (selected) {
                                      _onCategoryChanged(category);
                                    }
                                  },
                                  selectedColor: AppColors.primary.withOpacity(0.2),
                                  checkmarkColor: AppColors.primary,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Price list
          Expanded(
            child: _isLoading
                ? const LoadingWidget(message: 'Loading market prices...')
                : _filteredPrices.isEmpty
                    ? EmptyStateWidget(
                        title: context.t('noResultsFound'),
                        description: 'Try adjusting your search or filter criteria',
                        icon: Icons.search_off,
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          _loadCropPrices();
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          itemCount: _filteredPrices.length,
                          itemBuilder: (context, index) {
                            return _buildPriceCard(_filteredPrices[index]);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceCard(CropPrice price) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: CustomCard(
        child: Row(
          children: [
            // Crop image placeholder
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppBorderRadius.sm),
              ),
              child: Icon(
                _getCropIcon(price.category),
                color: AppColors.primary,
                size: 30,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            
            // Crop details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    price.cropName,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    price.market,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(price.category).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                        ),
                        child: Text(
                          price.category,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: _getCategoryColor(price.category),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Updated ${_getTimeAgo(price.lastUpdated)}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Price details
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${price.price.toStringAsFixed(2)}',
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'per ${price.unit}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                
                // Price change indicator
                if (price.previousPrice != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: price.isPriceUp
                          ? AppColors.success.withOpacity(0.1)
                          : price.isPriceDown
                              ? AppColors.error.withOpacity(0.1)
                              : AppColors.textLight.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          price.isPriceUp
                              ? Icons.arrow_upward
                              : price.isPriceDown
                                  ? Icons.arrow_downward
                                  : Icons.remove,
                          size: 12,
                          color: price.isPriceUp
                              ? AppColors.success
                              : price.isPriceDown
                                  ? AppColors.error
                                  : AppColors.textLight,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${price.priceChangePercentage.abs().toStringAsFixed(1)}%',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: price.isPriceUp
                                ? AppColors.success
                                : price.isPriceDown
                                    ? AppColors.error
                                    : AppColors.textLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCropIcon(String category) {
    switch (category) {
      case 'Vegetables':
        return Icons.eco;
      case 'Fruits':
        return Icons.apple;
      case 'Grains':
        return Icons.grain;
      default:
        return Icons.agriculture;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Vegetables':
        return AppColors.success;
      case 'Fruits':
        return AppColors.accent;
      case 'Grains':
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
