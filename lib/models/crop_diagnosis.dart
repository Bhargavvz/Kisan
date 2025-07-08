enum DiagnosisStatus { loading, success, error, healthy }

class CropDiagnosis {
  final String id;
  final String imagePath;
  final String cropType;
  final DiagnosisStatus status;
  final String? diseaseName;
  final String? diseaseDescription;
  final double? confidence;
  final List<String> treatments;
  final List<String> preventionMeasures;
  final DateTime diagnosisDate;
  final String? severity;

  CropDiagnosis({
    required this.id,
    required this.imagePath,
    required this.cropType,
    required this.status,
    this.diseaseName,
    this.diseaseDescription,
    this.confidence,
    required this.treatments,
    required this.preventionMeasures,
    required this.diagnosisDate,
    this.severity,
  });

  factory CropDiagnosis.fromJson(Map<String, dynamic> json) {
    return CropDiagnosis(
      id: json['id'],
      imagePath: json['imagePath'],
      cropType: json['cropType'],
      status: DiagnosisStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => DiagnosisStatus.loading,
      ),
      diseaseName: json['diseaseName'],
      diseaseDescription: json['diseaseDescription'],
      confidence: json['confidence']?.toDouble(),
      treatments: List<String>.from(json['treatments'] ?? []),
      preventionMeasures: List<String>.from(json['preventionMeasures'] ?? []),
      diagnosisDate: DateTime.parse(json['diagnosisDate']),
      severity: json['severity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'cropType': cropType,
      'status': status.name,
      'diseaseName': diseaseName,
      'diseaseDescription': diseaseDescription,
      'confidence': confidence,
      'treatments': treatments,
      'preventionMeasures': preventionMeasures,
      'diagnosisDate': diagnosisDate.toIso8601String(),
      'severity': severity,
    };
  }

  bool get isHealthy => status == DiagnosisStatus.healthy;
  bool get hasDiagnosis => status == DiagnosisStatus.success;
  bool get hasError => status == DiagnosisStatus.error;
  bool get isLoading => status == DiagnosisStatus.loading;
}
