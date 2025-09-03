import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String? phone;
  final String? profileImageUrl;
  final String? address;
  final String? city;
  final DateTime? birthDate;
  final String role; // 'customer', 'admin', 'artist'
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? preferences;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.phone,
    this.profileImageUrl,
    this.address,
    this.city,
    this.birthDate,
    this.role = 'customer',
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.preferences,
  });

  // Firebase'den map'e dönüştür
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'address': address,
      'city': city,
      'birthDate': birthDate != null ? Timestamp.fromDate(birthDate!) : null,
      'role': role,
      'isActive': isActive,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'preferences': preferences,
    };
  }

  // Firebase'den UserModel oluştur
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'],
      profileImageUrl: map['profileImageUrl'],
      address: map['address'],
      city: map['city'],
      birthDate: map['birthDate'] is Timestamp
          ? (map['birthDate'] as Timestamp).toDate()
          : null,
      role: map['role'] ?? 'customer',
      isActive: map['isActive'] ?? true,
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: map['updatedAt'] is Timestamp
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
      preferences: map['preferences'],
    );
  }

  // UserModel'i kopyala
  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? phone,
    String? profileImageUrl,
    String? address,
    String? city,
    DateTime? birthDate,
    String? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? preferences,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      address: address ?? this.address,
      city: city ?? this.city,
      birthDate: birthDate ?? this.birthDate,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      preferences: preferences ?? this.preferences,
    );
  }

  // İsim-soyisim ayrıştır
  String get firstName {
    final nameParts = name.split(' ');
    return nameParts.isNotEmpty ? nameParts.first : '';
  }

  String get lastName {
    final nameParts = name.split(' ');
    return nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
  }

  // Admin mi kontrol et
  bool get isAdmin => role == 'admin';

  // Artist mi kontrol et
  bool get isArtist => role == 'artist';

  // Customer mi kontrol et
  bool get isCustomer => role == 'customer';
}
