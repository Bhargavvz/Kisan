import 'package:cloud_firestore/cloud_firestore.dart';

enum DiagnosisStatus { pending, processing, completed, failed, healthy }

enum DiseaseSeverity { low, moderate, high, critical }

class DiagnosisResult {
  final String disease;
  final double confidence;
  final String description;
  final List<String> treatment;
  final List<String> prevention;
  final DiseaseSeverity severity;

  DiagnosisResult({
    required this.disease,
    required this.confidence,
    required this.description,
    required this.treatment,
    required this.prevention,
    required this.severity,
  });

  factory DiagnosisResult.fromJson(Map<String, dynamic> json) {
    return DiagnosisResult(
      disease: json['disease'] ?? '',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
      treatment: List<String>.from(json['treatment'] ?? []),
      prevention: List<String>.from(json['prevention'] ?? []),
      severity: DiseaseSeverity.values.firstWhere(
        (e) => e.name == json['severity'],
        orElse: () => DiseaseSeverity.moderate,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'disease': disease,
      'confidence': confidence,
      'description': description,
      'treatment': treatment,
      'prevention': prevention,
      'severity': severity.name,
    };
  }
}

class CropDiagnosis {
  final String id;
  final String userId;
  final String cropType;
  final String description;
  final String imageUrl;
  final String location;
  final DiagnosisStatus status;
  final DateTime submittedAt;
  final DateTime? completedAt;
  final DiagnosisResult? diagnosisResult;

  CropDiagnosis({
    required this.id,
    required this.userId,
    required this.cropType,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.status,
    required this.submittedAt,
    this.completedAt,
    this.diagnosisResult,
  });

  factory CropDiagnosis.fromJson(Map<String, dynamic> json) {
    return CropDiagnosis(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      cropType: json['cropType'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      location: json['location'] ?? '',
      status: DiagnosisStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => DiagnosisStatus.pending,
      ),
      submittedAt: DateTime.parse(json['submittedAt']),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      diagnosisResult: json['diagnosisResult'] != null
          ? DiagnosisResult.fromJson(json['diagnosisResult'])
          : null,
    );
  }

  factory CropDiagnosis.fromFirestore(Map<String, dynamic> json) {
    return CropDiagnosis(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      cropType: json['cropType'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      location: json['location'] ?? '',
      status: DiagnosisStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => DiagnosisStatus.pending,
      ),
      submittedAt: json['submittedAt']?.toDate() ?? DateTime.now(),
      completedAt: json['completedAt']?.toDate(),
      diagnosisResult: json['diagnosisResult'] != null
          ? DiagnosisResult.fromJson(json['diagnosisResult'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'cropType': cropType,
      'description': description,
      'imageUrl': imageUrl,
      'location': location,
      'status': status.name,
      'submittedAt': submittedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'diagnosisResult': diagnosisResult?.toJson(),
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'cropType': cropType,
      'description': description,
      'imageUrl': imageUrl,
      'location': location,
      'status': status.name,
      'submittedAt': Timestamp.fromDate(submittedAt),
      'completedAt':
          completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'diagnosisResult': diagnosisResult?.toJson(),
    };
  }

  bool get isPending => status == DiagnosisStatus.pending;
  bool get isProcessing => status == DiagnosisStatus.processing;
  bool get isCompleted => status == DiagnosisStatus.completed;
  bool get hasFailed => status == DiagnosisStatus.failed;
  bool get isHealthy => status == DiagnosisStatus.healthy;
  bool get hasDiagnosis => diagnosisResult != null;

  CropDiagnosis copyWith({
    String? id,
    String? userId,
    String? cropType,
    String? description,
    String? imageUrl,
    String? location,
    DiagnosisStatus? status,
    DateTime? submittedAt,
    DateTime? completedAt,
    DiagnosisResult? diagnosisResult,
  }) {
    return CropDiagnosis(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      cropType: cropType ?? this.cropType,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      status: status ?? this.status,
      submittedAt: submittedAt ?? this.submittedAt,
      completedAt: completedAt ?? this.completedAt,
      diagnosisResult: diagnosisResult ?? this.diagnosisResult,
    );
  }
}
