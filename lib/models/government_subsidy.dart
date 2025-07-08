import 'package:cloud_firestore/cloud_firestore.dart';

class GovernmentSubsidy {
  final String id;
  final String schemeName;
  final String description;
  final String category;
  final double maxAmount;
  final List<String> eligibilityCriteria;
  final List<String> requiredDocuments;
  final String applicationProcess;
  final DateTime deadline;
  final String department;
  final String? contactNumber;
  final String? website;
  final bool isActive;

  GovernmentSubsidy({
    required this.id,
    required this.schemeName,
    required this.description,
    required this.category,
    required this.maxAmount,
    required this.eligibilityCriteria,
    required this.requiredDocuments,
    required this.applicationProcess,
    required this.deadline,
    required this.department,
    this.contactNumber,
    this.website,
    required this.isActive,
  });

  factory GovernmentSubsidy.fromJson(Map<String, dynamic> json) {
    return GovernmentSubsidy(
      id: json['id'],
      schemeName: json['schemeName'],
      description: json['description'],
      category: json['category'],
      maxAmount: json['maxAmount'].toDouble(),
      eligibilityCriteria: List<String>.from(json['eligibilityCriteria']),
      requiredDocuments: List<String>.from(json['requiredDocuments']),
      applicationProcess: json['applicationProcess'],
      deadline: DateTime.parse(json['deadline']),
      department: json['department'],
      contactNumber: json['contactNumber'],
      website: json['website'],
      isActive: json['isActive'],
    );
  }

  factory GovernmentSubsidy.fromFirestore(Map<String, dynamic> json) {
    return GovernmentSubsidy(
      id: json['id'] ?? '',
      schemeName: json['schemeName'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      maxAmount: (json['maxAmount'] ?? 0.0).toDouble(),
      eligibilityCriteria: List<String>.from(json['eligibilityCriteria'] ?? []),
      requiredDocuments: List<String>.from(json['requiredDocuments'] ?? []),
      applicationProcess: json['applicationProcess'] ?? '',
      deadline: json['deadline']?.toDate() ?? DateTime.now(),
      department: json['department'] ?? '',
      contactNumber: json['contactNumber'],
      website: json['website'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'schemeName': schemeName,
      'description': description,
      'category': category,
      'maxAmount': maxAmount,
      'eligibilityCriteria': eligibilityCriteria,
      'requiredDocuments': requiredDocuments,
      'applicationProcess': applicationProcess,
      'deadline': deadline.toIso8601String(),
      'department': department,
      'contactNumber': contactNumber,
      'website': website,
      'isActive': isActive,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'schemeName': schemeName,
      'description': description,
      'category': category,
      'maxAmount': maxAmount,
      'eligibilityCriteria': eligibilityCriteria,
      'requiredDocuments': requiredDocuments,
      'applicationProcess': applicationProcess,
      'deadline': Timestamp.fromDate(deadline),
      'department': department,
      'contactNumber': contactNumber,
      'website': website,
      'isActive': isActive,
    };
  }

  bool get isDeadlineNear {
    final now = DateTime.now();
    final daysUntilDeadline = deadline.difference(now).inDays;
    return daysUntilDeadline <= 30 && daysUntilDeadline > 0;
  }

  bool get isExpired => DateTime.now().isAfter(deadline);
}
