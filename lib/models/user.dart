class User {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String address;
  final String language;
  final String? profileImageUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.language,
    this.profileImageUrl,
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
    };
  }

  User copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? address,
    String? language,
    String? profileImageUrl,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      language: language ?? this.language,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
