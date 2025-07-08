import '../models/crop_price.dart';
import '../models/crop_diagnosis.dart';
import '../models/government_subsidy.dart';
import '../models/user.dart' as app_user;

class MockData {
  static List<CropPrice> getCropPrices() {
    return [
      CropPrice(
        id: '1',
        cropName: 'Tomato',
        category: 'Vegetables',
        currentPrice: 45.0,
        unit: 'kg',
        marketName: 'APMC Bangalore',
        location: 'Bangalore',
        lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
        previousPrice: 40.0,
        imageUrl: 'assets/images/tomato.jpg',
      ),
      CropPrice(
        id: '2',
        cropName: 'Onion',
        category: 'Vegetables',
        currentPrice: 35.0,
        unit: 'kg',
        marketName: 'APMC Bangalore',
        location: 'Bangalore',
        lastUpdated: DateTime.now().subtract(const Duration(hours: 1)),
        previousPrice: 38.0,
        imageUrl: 'assets/images/onion.jpg',
      ),
      CropPrice(
        id: '3',
        cropName: 'Rice',
        category: 'Grains',
        currentPrice: 55.0,
        unit: 'kg',
        marketName: 'APMC Mysore',
        location: 'Mysore',
        lastUpdated: DateTime.now().subtract(const Duration(hours: 3)),
        previousPrice: 52.0,
        imageUrl: 'assets/images/rice.jpg',
      ),
      CropPrice(
        id: '4',
        cropName: 'Wheat',
        category: 'Grains',
        currentPrice: 42.0,
        unit: 'kg',
        marketName: 'APMC Bangalore',
        location: 'Bangalore',
        lastUpdated: DateTime.now().subtract(const Duration(hours: 4)),
        previousPrice: 44.0,
        imageUrl: 'assets/images/wheat.jpg',
      ),
      CropPrice(
        id: '5',
        cropName: 'Mango',
        category: 'Fruits',
        currentPrice: 85.0,
        unit: 'kg',
        marketName: 'APMC Bangalore',
        location: 'Bangalore',
        lastUpdated: DateTime.now().subtract(const Duration(hours: 1)),
        previousPrice: 80.0,
        imageUrl: 'assets/images/mango.jpg',
      ),
      CropPrice(
        id: '6',
        cropName: 'Banana',
        category: 'Fruits',
        currentPrice: 25.0,
        unit: 'kg',
        marketName: 'APMC Mysore',
        location: 'Mysore',
        lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
        previousPrice: 28.0,
        imageUrl: 'assets/images/banana.jpg',
      ),
      CropPrice(
        id: '7',
        cropName: 'Potato',
        category: 'Vegetables',
        currentPrice: 28.0,
        unit: 'kg',
        marketName: 'APMC Bangalore',
        location: 'Bangalore',
        lastUpdated: DateTime.now().subtract(const Duration(hours: 3)),
        previousPrice: 25.0,
        imageUrl: 'assets/images/potato.jpg',
      ),
      CropPrice(
        id: '8',
        cropName: 'Cabbage',
        category: 'Vegetables',
        currentPrice: 18.0,
        unit: 'kg',
        marketName: 'APMC Mysore',
        location: 'Mysore',
        lastUpdated: DateTime.now().subtract(const Duration(hours: 1)),
        previousPrice: 20.0,
        imageUrl: 'assets/images/cabbage.jpg',
      ),
    ];
  }

  static List<GovernmentSubsidy> getGovernmentSubsidies() {
    return [
      GovernmentSubsidy(
        id: '1',
        schemeName: 'PM-KISAN',
        description: 'Financial support to farmers for income security',
        category: 'Income Support',
        maxAmount: 6000.0,
        eligibilityCriteria: [
          'All landholding farmers',
          'Aadhaar card mandatory',
          'Valid land records',
        ],
        requiredDocuments: [
          'Aadhaar Card',
          'Land Records',
          'Bank Account Details',
        ],
        applicationProcess: 'Apply online at pmkisan.gov.in',
        deadline: DateTime.now().add(const Duration(days: 90)),
        department: 'Department of Agriculture',
        contactNumber: '1800-180-1551',
        website: 'https://pmkisan.gov.in',
        isActive: true,
      ),
      GovernmentSubsidy(
        id: '2',
        schemeName: 'Soil Health Card Scheme',
        description: 'Free soil testing and advisory services',
        category: 'Soil Health',
        maxAmount: 500.0,
        eligibilityCriteria: [
          'All farmers',
          'Land ownership proof',
        ],
        requiredDocuments: [
          'Land Records',
          'Farmer ID',
        ],
        applicationProcess: 'Contact nearest agriculture office',
        deadline: DateTime.now().add(const Duration(days: 120)),
        department: 'Department of Agriculture',
        contactNumber: '1800-180-1551',
        isActive: true,
      ),
      GovernmentSubsidy(
        id: '3',
        schemeName: 'Pradhan Mantri Krishi Sinchai Yojana',
        description: 'Irrigation facility development and water conservation',
        category: 'Irrigation',
        maxAmount: 50000.0,
        eligibilityCriteria: [
          'Farmers with irrigation needs',
          'Land ownership proof',
          'Water source availability',
        ],
        requiredDocuments: [
          'Land Records',
          'Water Source Certificate',
          'Project Proposal',
        ],
        applicationProcess: 'Apply through district collector office',
        deadline: DateTime.now().add(const Duration(days: 60)),
        department: 'Department of Agriculture',
        contactNumber: '1800-180-1551',
        isActive: true,
      ),
      GovernmentSubsidy(
        id: '4',
        schemeName: 'National Agriculture Market (e-NAM)',
        description: 'Online trading platform for agricultural commodities',
        category: 'Marketing',
        maxAmount: 0.0,
        eligibilityCriteria: [
          'All farmers',
          'Valid mobile number',
        ],
        requiredDocuments: [
          'Farmer ID',
          'Mobile Number',
        ],
        applicationProcess: 'Register online at enam.gov.in',
        deadline: DateTime.now().add(const Duration(days: 365)),
        department: 'Department of Agriculture',
        contactNumber: '1800-180-1551',
        website: 'https://enam.gov.in',
        isActive: true,
      ),
    ];
  }

  static List<CropDiagnosis> getDiagnosisHistory() {
    return [
      CropDiagnosis(
        id: '1',
        userId: 'mock_user_id',
        cropType: 'Tomato',
        description: 'Tomato plants showing signs of disease',
        imageUrl: 'assets/images/tomato_disease.jpg',
        location: 'Bangalore',
        status: DiagnosisStatus.completed,
        submittedAt: DateTime.now().subtract(const Duration(days: 2)),
        completedAt: DateTime.now().subtract(const Duration(days: 1)),
        diagnosisResult: DiagnosisResult(
          disease: 'Late Blight',
          confidence: 0.89,
          description: 'A fungal disease that affects tomato leaves and fruits',
          treatment: [
            'Apply copper-based fungicides',
            'Remove affected leaves',
            'Improve air circulation',
          ],
          prevention: [
            'Avoid overhead watering',
            'Plant disease-resistant varieties',
            'Maintain proper spacing',
          ],
          severity: DiseaseSeverity.moderate,
        ),
      ),
      CropDiagnosis(
        id: '2',
        userId: 'mock_user_id',
        cropType: 'Wheat',
        description: 'Healthy wheat crop check',
        imageUrl: 'assets/images/healthy_crop.jpg',
        location: 'Mysore',
        status: DiagnosisStatus.healthy,
        submittedAt: DateTime.now().subtract(const Duration(days: 5)),
        completedAt: DateTime.now().subtract(const Duration(days: 4)),
        diagnosisResult: DiagnosisResult(
          disease: 'Healthy',
          confidence: 0.96,
          description: 'Crop appears healthy with no signs of disease',
          treatment: [],
          prevention: [
            'Continue regular watering',
            'Monitor for pests',
            'Maintain soil health',
          ],
          severity: DiseaseSeverity.low,
        ),
      ),
      CropDiagnosis(
        id: '3',
        userId: 'mock_user_id',
        cropType: 'Rice',
        description: 'Rice plants with spotted leaves',
        imageUrl: 'assets/images/rice_disease.jpg',
        location: 'Bangalore',
        status: DiagnosisStatus.completed,
        submittedAt: DateTime.now().subtract(const Duration(days: 7)),
        completedAt: DateTime.now().subtract(const Duration(days: 6)),
        diagnosisResult: DiagnosisResult(
          disease: 'Blast Disease',
          confidence: 0.94,
          description: 'A fungal disease causing lesions on rice leaves',
          treatment: [
            'Apply systemic fungicides',
            'Use resistant varieties',
            'Manage water levels',
          ],
          prevention: [
            'Avoid excessive nitrogen',
            'Maintain proper water management',
            'Use clean seeds',
          ],
          severity: DiseaseSeverity.high,
        ),
      ),
    ];
  }

  static app_user.User getMockUser() {
    return app_user.User(
      id: '1',
      name: 'Ramesh Kumar',
      email: 'ramesh.kumar@example.com',
      phoneNumber: '+91 9876543210',
      address: 'Village Kadakol, Hubli, Karnataka 580024',
      language: 'kn',
      profileImageUrl: 'assets/images/user_avatar.jpg',
      isGuest: false,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
      preferences: app_user.UserPreferences(
        language: 'kn',
        theme: 'system',
        notifications: true,
        locationAccess: false,
      ),
    );
  }

  static List<Map<String, dynamic>> getFAQs() {
    return [
      {
        'question': 'How accurate is the crop disease diagnosis?',
        'answer':
            'Our AI model has an accuracy of over 90% for most common crop diseases. However, we recommend consulting with agricultural experts for complex cases.',
      },
      {
        'question': 'How often are market prices updated?',
        'answer':
            'Market prices are updated every hour from various APMC markets across Karnataka.',
      },
      {
        'question': 'Can I use the app offline?',
        'answer':
            'Yes, you can access previously downloaded content offline. However, real-time features like market prices require internet connection.',
      },
      {
        'question': 'How do I apply for government subsidies?',
        'answer':
            'Each subsidy scheme has specific application processes. Click on the scheme for detailed instructions and required documents.',
      },
      {
        'question': 'Is my data secure?',
        'answer':
            'Yes, we follow strict data protection protocols. Your personal information is encrypted and never shared with third parties.',
      },
    ];
  }

  static List<Map<String, String>> getTutorials() {
    return [
      {
        'title': 'How to diagnose crop diseases',
        'description':
            'Learn how to take proper photos for accurate disease diagnosis',
        'duration': '3 min',
        'videoUrl': 'assets/videos/crop_diagnosis_tutorial.mp4',
      },
      {
        'title': 'Understanding market prices',
        'description':
            'Get insights on how to read and interpret market price trends',
        'duration': '5 min',
        'videoUrl': 'assets/videos/market_prices_tutorial.mp4',
      },
      {
        'title': 'Applying for subsidies',
        'description': 'Step-by-step guide to apply for government schemes',
        'duration': '7 min',
        'videoUrl': 'assets/videos/subsidies_tutorial.mp4',
      },
    ];
  }

  static Map<String, int> getDashboardStats() {
    return {
      'totalDiagnoses': 15,
      'healthyPlants': 8,
      'diseasesDetected': 7,
      'subsidiesApplied': 3,
      'marketUpdates': 24,
    };
  }
}
