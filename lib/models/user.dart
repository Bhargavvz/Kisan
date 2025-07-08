import 'package:cloud_firestore/cloud_firestore.dart';

class UserPreferences {
  final String language;
  final String theme;
  final bool notifications;
  final bool locationAccess;

  UserPreferences({
    required this.language,
    required this.theme,
    required this.notifications,
    required this.locationAccess,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      language: json['language'] ?? 'en',
      theme: json['theme'] ?? 'system',
      notifications: json['notifications'] ?? true,
      locationAccess: json['locationAccess'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'theme': theme,
      'notifications': notifications,
      'locationAccess': locationAccess,
    };
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String address;
  final String language;
  final String? profileImageUrl;
  final bool isGuest;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;
  final UserPreferences? preferences;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.language,
    this.profileImageUrl,
    this.isGuest = false,
    this.createdAt,
    this.lastLoginAt,
    this.preferences,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      language: json['language'],
      profileImageUrl: json['profileImageUrl'],
      isGuest: json['isGuest'] ?? false,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'])
          : null,
      preferences: json['preferences'] != null
          ? UserPreferences.fromJson(json['preferences'])
          : null,
    );
  }

  factory User.fromFirestore(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'] ?? '',
      language: json['language'] ?? 'en',
      profileImageUrl: json['profileImageUrl'],
      isGuest: json['isGuest'] ?? false,
      createdAt: json['createdAt']?.toDate(),
      lastLoginAt: json['lastLoginAt']?.toDate(),
      preferences: json['preferences'] != null
          ? UserPreferences.fromJson(json['preferences'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'language': language,
      'profileImageUrl': profileImageUrl,
      'isGuest': isGuest,
      'createdAt': createdAt?.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'preferences': preferences?.toJson(),
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'language': language,
      'profileImageUrl': profileImageUrl,
      'isGuest': isGuest,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'lastLoginAt': lastLoginAt != null
          ? Timestamp.fromDate(lastLoginAt!)
          : FieldValue.serverTimestamp(),
      'preferences': preferences?.toJson(),
    };
  }

  User copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? address,
    String? language,
    String? profileImageUrl,
    bool? isGuest,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    UserPreferences? preferences,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      language: language ?? this.language,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isGuest: isGuest ?? this.isGuest,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      preferences: preferences ?? this.preferences,
    );
  }
}
