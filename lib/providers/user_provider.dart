import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/storage_service.dart';
import 'dart:io';

class UserProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();
  final StorageService _storageService = StorageService();

  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  // Kullanıcı giriş durumunu dinle
  void initUserListener() {
    _authService.authStateChanges.listen((user) async {
      if (user != null) {
        await loadUserData();
      } else {
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  // Kullanıcı verilerini yükle
  Future<void> loadUserData() async {
    final user = _authService.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final userData = await _authService.getUserData();
      if (userData != null) {
        _currentUser = UserModel.fromMap(userData);
      }
    } catch (e) {
      print('Error loading user data: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Kullanıcı profili güncelle
  Future<bool> updateProfile({
    String? name,
    String? phone,
    String? address,
    String? city,
    DateTime? birthDate,
    File? profileImage,
  }) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> updateData = {};

      if (name != null) updateData['name'] = name;
      if (phone != null) updateData['phone'] = phone;
      if (address != null) updateData['address'] = address;
      if (city != null) updateData['city'] = city;
      if (birthDate != null) updateData['birthDate'] = birthDate;

      // Profil fotoğrafı yükle
      if (profileImage != null) {
        final imageUrl = await _storageService.uploadProfilePicture(
          profileImage,
          _currentUser!.uid,
        );
        if (imageUrl != null) {
          updateData['profileImageUrl'] = imageUrl;
        }
      }

      final success = await _authService.updateUserProfile(updateData);

      if (success) {
        // Yerel state'i güncelle
        _currentUser = _currentUser!.copyWith(
          name: name ?? _currentUser!.name,
          phone: phone ?? _currentUser!.phone,
          address: address ?? _currentUser!.address,
          city: city ?? _currentUser!.city,
          birthDate: birthDate ?? _currentUser!.birthDate,
          profileImageUrl:
              updateData['profileImageUrl'] ?? _currentUser!.profileImageUrl,
        );

        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error updating profile: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Kullanıcı tercihlerini güncelle
  Future<bool> updatePreferences(Map<String, dynamic> preferences) async {
    if (_currentUser == null) return false;

    try {
      final updateData = {
        'preferences': {..._currentUser!.preferences ?? {}, ...preferences},
      };

      final success = await _authService.updateUserProfile(updateData);

      if (success) {
        _currentUser = _currentUser!.copyWith(
          preferences: updateData['preferences'],
        );
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error updating preferences: $e');
    }

    return false;
  }

  // Çıkış yap
  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }

  // Şifre sıfırlama emaili gönder
  Future<bool> sendPasswordResetEmail(String email) async {
    return await _authService.sendPasswordResetEmail(email);
  }
}
