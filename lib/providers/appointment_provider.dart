import 'dart:async';
import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';

class AppointmentProvider extends ChangeNotifier {
  final List<Appointment> _appointments = [];
  final DatabaseService _databaseService = DatabaseService();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  List<Appointment> get appointments => _appointments;
  bool get isLoading => _isLoading;

  List<Appointment> get pendingAppointments => _appointments
      .where((a) => a.status == AppointmentStatus.pending)
      .toList();
  List<Appointment> get approvedAppointments => _appointments
      .where((a) => a.status == AppointmentStatus.approved)
      .toList();
  List<Appointment> get rejectedAppointments => _appointments
      .where((a) => a.status == AppointmentStatus.rejected)
      .toList();

  // Firebase'den randevuları yükle
  Future<void> loadUserAppointments() async {
    final user = _authService.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final appointmentData = await _databaseService.getUserAppointments(
        user.uid,
      );
      _appointments.clear();

      for (var data in appointmentData) {
        _appointments.add(Appointment.fromMap(data));
      }
    } catch (e) {
      print('Error loading appointments: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Firebase'e randevu ekle
  Future<bool> addAppointment(Appointment appointment) async {
    final user = _authService.currentUser;
    if (user == null) return false;

    try {
      final appointmentData = appointment.toMap();
      appointmentData['userId'] = user.uid;

      final success = await _databaseService.bookAppointment(appointmentData);

      if (success) {
        _appointments.add(appointment);
        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      print('Error adding appointment: $e');
      return false;
    }
  }

  // Randevu durumunu güncelle
  Future<bool> updateAppointmentStatus(
    String appointmentId,
    AppointmentStatus status,
  ) async {
    try {
      String statusString = status.toString().split('.').last;
      final success = await _databaseService.updateAppointmentStatus(
        appointmentId,
        statusString,
      );

      if (success) {
        final index = _appointments.indexWhere((a) => a.id == appointmentId);
        if (index != -1) {
          _appointments[index].status = status;
          notifyListeners();
        }
        return true;
      }

      return false;
    } catch (e) {
      print('Error updating appointment status: $e');
      return false;
    }
  }

  // Real-time appointment updates için stream
  Stream<List<Appointment>> getUserAppointmentsStream() {
    final user = _authService.currentUser;
    if (user == null) return Stream.value([]);

    return _databaseService.appointments
        .where('userId', isEqualTo: user.uid)
        .orderBy('appointmentDate', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return Appointment.fromMap(data);
          }).toList();
        });
  }
}
