import 'package:cloud_firestore/cloud_firestore.dart';

class CropPrice {
  final String id;
  final String cropName;
  final String cropNameLower;
  final String category;
  final double currentPrice;
  final double? previousPrice;
  final String unit;
  final String marketName;
  final String location;
  final DateTime lastUpdated;
  final String? imageUrl;
  final String? description;

  CropPrice({
    required this.id,
    required this.cropName,
    required this.category,
    required this.currentPrice,
    required this.unit,
    required this.marketName,
    required this.location,
    required this.lastUpdated,
    this.previousPrice,
    this.imageUrl,
    this.description,
  }) : cropNameLower = cropName.toLowerCase();

  factory CropPrice.fromJson(Map<String, dynamic> json) {
    return CropPrice(
      id: json['id'] ?? '',
      cropName: json['cropName'] ?? '',
      category: json['category'] ?? '',
      currentPrice: (json['currentPrice'] ?? json['price'] ?? 0.0).toDouble(),
      unit: json['unit'] ?? 'kg',
      marketName: json['marketName'] ?? json['market'] ?? '',
      location: json['location'] ?? '',
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
      previousPrice: json['previousPrice']?.toDouble(),
      imageUrl: json['imageUrl'],
      description: json['description'],
    );
  }

  factory CropPrice.fromFirestore(Map<String, dynamic> json) {
    return CropPrice(
      id: json['id'] ?? '',
      cropName: json['cropName'] ?? '',
      category: json['category'] ?? '',
      currentPrice: (json['currentPrice'] ?? json['price'] ?? 0.0).toDouble(),
      unit: json['unit'] ?? 'kg',
      marketName: json['marketName'] ?? json['market'] ?? '',
      location: json['location'] ?? '',
      lastUpdated: json['lastUpdated']?.toDate() ?? DateTime.now(),
      previousPrice: json['previousPrice']?.toDouble(),
      imageUrl: json['imageUrl'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cropName': cropName,
      'cropNameLower': cropNameLower,
      'category': category,
      'currentPrice': currentPrice,
      'previousPrice': previousPrice,
      'unit': unit,
      'marketName': marketName,
      'location': location,
      'lastUpdated': lastUpdated.toIso8601String(),
      'imageUrl': imageUrl,
      'description': description,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'cropName': cropName,
      'cropNameLower': cropNameLower,
      'category': category,
      'currentPrice': currentPrice,
      'previousPrice': previousPrice,
      'unit': unit,
      'marketName': marketName,
      'location': location,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
      'imageUrl': imageUrl,
      'description': description,
    };
  }

  // Backward compatibility
  double get price => currentPrice;
  String get market => marketName;

  double get priceChange {
    if (previousPrice == null) return 0.0;
    return currentPrice - previousPrice!;
  }

  double get priceChangePercentage {
    if (previousPrice == null || previousPrice == 0) return 0.0;
    return (priceChange / previousPrice!) * 100;
  }

  bool get isPriceUp => priceChange > 0;
  bool get isPriceDown => priceChange < 0;
  bool get isPriceStable => priceChange == 0;

  CropPrice copyWith({
    String? id,
    String? cropName,
    String? category,
    double? currentPrice,
    double? previousPrice,
    String? unit,
    String? marketName,
    String? location,
    DateTime? lastUpdated,
    String? imageUrl,
    String? description,
  }) {
    return CropPrice(
      id: id ?? this.id,
      cropName: cropName ?? this.cropName,
      category: category ?? this.category,
      currentPrice: currentPrice ?? this.currentPrice,
      previousPrice: previousPrice ?? this.previousPrice,
      unit: unit ?? this.unit,
      marketName: marketName ?? this.marketName,
      location: location ?? this.location,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
    );
  }
}
