import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  final String? id;
  final String name;
  final String description;
  final double price;
  final String? iconName;
  final IconData? icon;
  final String? imageUrl;
  final List<String>? imageUrls;
  final String category;
  final int duration; // dakika cinsinden
  final bool isActive;
  final String? artist;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Service({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    this.iconName,
    this.icon,
    this.imageUrl,
    this.imageUrls,
    this.category = 'nail',
    this.duration = 60,
    this.isActive = true,
    this.artist,
    this.createdAt,
    this.updatedAt,
  });

  // Firebase'den map'e dönüştür
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'iconName': iconName,
      'imageUrl': imageUrl,
      'imageUrls': imageUrls,
      'category': category,
      'duration': duration,
      'isActive': isActive,
      'artist': artist,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  // Firebase'den Service oluştur
  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      id: map['id'],
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      iconName: map['iconName'],
      imageUrl: map['imageUrl'],
      imageUrls: map['imageUrls'] != null
          ? List<String>.from(map['imageUrls'])
          : null,
      category: map['category'] ?? 'nail',
      duration: map['duration'] ?? 60,
      isActive: map['isActive'] ?? true,
      artist: map['artist'],
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: map['updatedAt'] is Timestamp
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  // Service'i kopyala
  Service copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? iconName,
    IconData? icon,
    String? imageUrl,
    List<String>? imageUrls,
    String? category,
    int? duration,
    bool? isActive,
    String? artist,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Service(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      iconName: iconName ?? this.iconName,
      icon: icon ?? this.icon,
      imageUrl: imageUrl ?? this.imageUrl,
      imageUrls: imageUrls ?? this.imageUrls,
      category: category ?? this.category,
      duration: duration ?? this.duration,
      isActive: isActive ?? this.isActive,
      artist: artist ?? this.artist,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Fiyatı formatla
  String get formattedPrice => '${price.toStringAsFixed(0)} ₺';
}
