import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../services/database_service.dart';

class ServicesProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  List<Service> _services = [];
  bool _isLoading = false;
  String _selectedCategory = 'all';

  List<Service> get services => _services;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  // Kategoriye göre filtrelenmiş servisler
  List<Service> get filteredServices {
    if (_selectedCategory == 'all') {
      return _services.where((service) => service.isActive).toList();
    }
    return _services
        .where(
          (service) =>
              service.category == _selectedCategory && service.isActive,
        )
        .toList();
  }

  // Servisleri yükle
  Future<void> loadServices() async {
    _isLoading = true;
    notifyListeners();

    try {
      final servicesData = await _databaseService.getServices();
      _services = servicesData.map((data) => Service.fromMap(data)).toList();
    } catch (e) {
      print('Error loading services: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Kategori seç
  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Servis ekle (admin için)
  Future<bool> addService(Service service) async {
    try {
      final success = await _databaseService.addService(service.toMap());

      if (success) {
        await loadServices(); // Listeyi yenile
        return true;
      }
    } catch (e) {
      print('Error adding service: $e');
    }

    return false;
  }

  // Servis ID'sine göre servis bul
  Service? getServiceById(String id) {
    try {
      return _services.firstWhere((service) => service.id == id);
    } catch (e) {
      return null;
    }
  }

  // Real-time services updates için stream
  Stream<List<Service>> getServicesStream() {
    return _databaseService.getCollectionStream('services').map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Service.fromMap(data);
      }).toList();
    });
  }

  // Kategorileri getir
  List<String> get categories {
    final categories = _services
        .where((service) => service.isActive)
        .map((service) => service.category)
        .toSet()
        .toList();
    categories.insert(0, 'all');
    return categories;
  }
}
