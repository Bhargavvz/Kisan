import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';
import '../models/crop_price.dart';

class MarketPricesService {
  static final MarketPricesService _instance = MarketPricesService._internal();
  factory MarketPricesService() => _instance;
  MarketPricesService._internal();

  final FirebaseService _firebaseService = FirebaseService();

  // Get current market prices
  Stream<List<CropPrice>> getMarketPrices({
    String? location,
    String? cropType,
    int limit = 50,
  }) {
    try {
      Query query = _firebaseService.cropPricesCollection
          .orderBy('lastUpdated', descending: true);

      if (location != null && location.isNotEmpty) {
        query = query.where('location', isEqualTo: location);
      }

      if (cropType != null && cropType.isNotEmpty) {
        query = query.where('cropName', isEqualTo: cropType);
      }

      return query.limit(limit).snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return CropPrice.fromFirestore(data);
        }).toList();
      });
    } catch (e) {
      _firebaseService.logError('Get market prices error', error: e);
      return Stream.value([]);
    }
  }

  // Add/Update crop price (for admin users)
  Future<void> updateCropPrice(CropPrice cropPrice) async {
    try {
      String docId =
          '${cropPrice.cropName}_${cropPrice.location}_${cropPrice.marketName}';

      await _firebaseService.cropPricesCollection.doc(docId).set(
            cropPrice.toFirestore(),
            SetOptions(merge: true),
          );

      await _firebaseService.logEvent('crop_price_updated', parameters: {
        'crop_name': cropPrice.cropName,
        'location': cropPrice.location,
        'market': cropPrice.marketName,
        'price': cropPrice.currentPrice,
      });
    } catch (e) {
      _firebaseService.logError('Update crop price error', error: e);
      rethrow;
    }
  }

  // Get price history for a specific crop
  Future<List<CropPrice>> getPriceHistory({
    required String cropName,
    required String location,
    int daysBack = 30,
  }) async {
    try {
      DateTime startDate = DateTime.now().subtract(Duration(days: daysBack));

      QuerySnapshot snapshot = await _firebaseService.cropPricesCollection
          .where('cropName', isEqualTo: cropName)
          .where('location', isEqualTo: location)
          .where('lastUpdated', isGreaterThan: Timestamp.fromDate(startDate))
          .orderBy('lastUpdated', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return CropPrice.fromFirestore(data);
      }).toList();
    } catch (e) {
      _firebaseService.logError('Get price history error', error: e);
      return [];
    }
  }

  // Get available locations
  Future<List<String>> getAvailableLocations() async {
    try {
      QuerySnapshot snapshot =
          await _firebaseService.cropPricesCollection.get();

      Set<String> locations = {};
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String location = data['location'] ?? '';
        if (location.isNotEmpty) {
          locations.add(location);
        }
      }

      List<String> sortedLocations = locations.toList()..sort();

      await _firebaseService.logEvent('locations_fetched', parameters: {
        'count': sortedLocations.length,
      });

      return sortedLocations;
    } catch (e) {
      _firebaseService.logError('Get available locations error', error: e);
      return [];
    }
  }

  // Get available crop types
  Future<List<String>> getAvailableCrops() async {
    try {
      QuerySnapshot snapshot =
          await _firebaseService.cropPricesCollection.get();

      Set<String> crops = {};
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String cropName = data['cropName'] ?? '';
        if (cropName.isNotEmpty) {
          crops.add(cropName);
        }
      }

      List<String> sortedCrops = crops.toList()..sort();

      await _firebaseService.logEvent('crops_fetched', parameters: {
        'count': sortedCrops.length,
      });

      return sortedCrops;
    } catch (e) {
      _firebaseService.logError('Get available crops error', error: e);
      return [];
    }
  }

  // Search crops by name
  Future<List<CropPrice>> searchCrops(String searchTerm) async {
    try {
      String lowerSearch = searchTerm.toLowerCase();

      QuerySnapshot snapshot = await _firebaseService.cropPricesCollection
          .where('cropNameLower', isGreaterThanOrEqualTo: lowerSearch)
          .where('cropNameLower', isLessThan: lowerSearch + 'z')
          .limit(20)
          .get();

      List<CropPrice> results = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return CropPrice.fromFirestore(data);
      }).toList();

      await _firebaseService.logEvent('crops_searched', parameters: {
        'search_term': searchTerm,
        'results_count': results.length,
      });

      return results;
    } catch (e) {
      _firebaseService.logError('Search crops error', error: e);
      return [];
    }
  }

  // Get price alerts for user
  Stream<List<Map<String, dynamic>>> getPriceAlerts() {
    try {
      String? userId = _firebaseService.currentUser?.uid;
      if (userId == null) return Stream.value([]);

      return _firebaseService.firestore
          .collection('price_alerts')
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      _firebaseService.logError('Get price alerts error', error: e);
      return Stream.value([]);
    }
  }

  // Set price alert
  Future<void> setPriceAlert({
    required String cropName,
    required String location,
    required double targetPrice,
    required String alertType, // 'above' or 'below'
  }) async {
    try {
      String? userId = _firebaseService.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      Map<String, dynamic> alertData = {
        'userId': userId,
        'cropName': cropName,
        'location': location,
        'targetPrice': targetPrice,
        'alertType': alertType,
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firebaseService.firestore
          .collection('price_alerts')
          .add(alertData);

      await _firebaseService.logEvent('price_alert_set', parameters: {
        'crop_name': cropName,
        'location': location,
        'target_price': targetPrice,
        'alert_type': alertType,
      });
    } catch (e) {
      _firebaseService.logError('Set price alert error', error: e);
      rethrow;
    }
  }

  // Remove price alert
  Future<void> removePriceAlert(String alertId) async {
    try {
      await _firebaseService.firestore
          .collection('price_alerts')
          .doc(alertId)
          .delete();

      await _firebaseService.logEvent('price_alert_removed', parameters: {
        'alert_id': alertId,
      });
    } catch (e) {
      _firebaseService.logError('Remove price alert error', error: e);
      rethrow;
    }
  }

  // Get market trends
  Future<Map<String, dynamic>> getMarketTrends({
    required String cropName,
    int daysBack = 7,
  }) async {
    try {
      DateTime startDate = DateTime.now().subtract(Duration(days: daysBack));

      QuerySnapshot snapshot = await _firebaseService.cropPricesCollection
          .where('cropName', isEqualTo: cropName)
          .where('lastUpdated', isGreaterThan: Timestamp.fromDate(startDate))
          .orderBy('lastUpdated', descending: false)
          .get();

      if (snapshot.docs.isEmpty) {
        return {'trend': 'stable', 'percentage': 0.0, 'data': []};
      }

      List<double> prices = snapshot.docs.map<double>((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return (data['currentPrice'] ?? 0.0).toDouble();
      }).toList();

      double oldestPrice = prices.first;
      double latestPrice = prices.last;
      double percentageChange =
          ((latestPrice - oldestPrice) / oldestPrice) * 100;

      String trend = 'stable';
      if (percentageChange > 5) {
        trend = 'rising';
      } else if (percentageChange < -5) {
        trend = 'falling';
      }

      await _firebaseService.logEvent('market_trends_fetched', parameters: {
        'crop_name': cropName,
        'trend': trend,
        'percentage_change': percentageChange,
      });

      return {
        'trend': trend,
        'percentage': percentageChange,
        'data': prices,
        'oldestPrice': oldestPrice,
        'latestPrice': latestPrice,
      };
    } catch (e) {
      _firebaseService.logError('Get market trends error', error: e);
      return {'trend': 'stable', 'percentage': 0.0, 'data': []};
    }
  }

  // Batch update multiple crop prices (for data import)
  Future<void> batchUpdatePrices(List<CropPrice> cropPrices) async {
    try {
      WriteBatch batch = _firebaseService.firestore.batch();

      for (CropPrice cropPrice in cropPrices) {
        String docId =
            '${cropPrice.cropName}_${cropPrice.location}_${cropPrice.marketName}';
        DocumentReference docRef =
            _firebaseService.cropPricesCollection.doc(docId);
        batch.set(docRef, cropPrice.toFirestore(), SetOptions(merge: true));
      }

      await batch.commit();

      await _firebaseService.logEvent('batch_prices_updated', parameters: {
        'count': cropPrices.length,
      });
    } catch (e) {
      _firebaseService.logError('Batch update prices error', error: e);
      rethrow;
    }
  }
}
