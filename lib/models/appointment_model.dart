import 'package:cloud_firestore/cloud_firestore.dart';

enum AppointmentStatus { pending, approved, rejected }

class Appointment {
  final String? id;
  final String serviceName;
  final String artist;
  final DateTime date;
  final String branch;
  final String? userId;
  final String? serviceId;
  final double? price;
  final String? notes;
  AppointmentStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Appointment({
    this.id,
    required this.serviceName,
    required this.artist,
    required this.date,
    required this.branch,
    this.userId,
    this.serviceId,
    this.price,
    this.notes,
    this.status = AppointmentStatus.pending,
    this.createdAt,
    this.updatedAt,
  });

  // Firebase'den map'e dönüştür
  Map<String, dynamic> toMap() {
    return {
      'serviceName': serviceName,
      'artist': artist,
      'appointmentDate': Timestamp.fromDate(date),
      'branch': branch,
      'userId': userId,
      'serviceId': serviceId,
      'price': price,
      'notes': notes,
      'status': status.toString().split('.').last,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  // Firebase'den Appointment oluştur
  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'],
      serviceName: map['serviceName'] ?? '',
      artist: map['artist'] ?? '',
      date: map['appointmentDate'] is Timestamp
          ? (map['appointmentDate'] as Timestamp).toDate()
          : DateTime.parse(map['appointmentDate']),
      branch: map['branch'] ?? '',
      userId: map['userId'],
      serviceId: map['serviceId'],
      price: map['price']?.toDouble(),
      notes: map['notes'],
      status: _stringToStatus(map['status'] ?? 'pending'),
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: map['updatedAt'] is Timestamp
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  // String'den AppointmentStatus'e dönüştür
  static AppointmentStatus _stringToStatus(String status) {
    switch (status) {
      case 'approved':
        return AppointmentStatus.approved;
      case 'rejected':
        return AppointmentStatus.rejected;
      default:
        return AppointmentStatus.pending;
    }
  }

  // Appointment'i kopyala
  Appointment copyWith({
    String? id,
    String? serviceName,
    String? artist,
    DateTime? date,
    String? branch,
    String? userId,
    String? serviceId,
    double? price,
    String? notes,
    AppointmentStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Appointment(
      id: id ?? this.id,
      serviceName: serviceName ?? this.serviceName,
      artist: artist ?? this.artist,
      date: date ?? this.date,
      branch: branch ?? this.branch,
      userId: userId ?? this.userId,
      serviceId: serviceId ?? this.serviceId,
      price: price ?? this.price,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
