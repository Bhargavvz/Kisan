class CropPrice {
  final String id;
  final String cropName;
  final String category;
  final double price;
  final String unit;
  final String market;
  final DateTime lastUpdated;
  final double? previousPrice;
  final String? imageUrl;

  CropPrice({
    required this.id,
    required this.cropName,
    required this.category,
    required this.price,
    required this.unit,
    required this.market,
    required this.lastUpdated,
    this.previousPrice,
    this.imageUrl,
  });

  factory CropPrice.fromJson(Map<String, dynamic> json) {
    return CropPrice(
      id: json['id'],
      cropName: json['cropName'],
      category: json['category'],
      price: json['price'].toDouble(),
      unit: json['unit'],
      market: json['market'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
      previousPrice: json['previousPrice']?.toDouble(),
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cropName': cropName,
      'category': category,
      'price': price,
      'unit': unit,
      'market': market,
      'lastUpdated': lastUpdated.toIso8601String(),
      'previousPrice': previousPrice,
      'imageUrl': imageUrl,
    };
  }

  double get priceChange {
    if (previousPrice == null) return 0.0;
    return price - previousPrice!;
  }

  double get priceChangePercentage {
    if (previousPrice == null || previousPrice == 0) return 0.0;
    return (priceChange / previousPrice!) * 100;
  }

  bool get isPriceUp => priceChange > 0;
  bool get isPriceDown => priceChange < 0;
  bool get isPriceStable => priceChange == 0;
}
