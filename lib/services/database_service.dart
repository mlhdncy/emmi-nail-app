import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections
  CollectionReference get users => _firestore.collection('users');
  CollectionReference get services => _firestore.collection('services');
  CollectionReference get products => _firestore.collection('products');
  CollectionReference get appointments => _firestore.collection('appointments');
  CollectionReference get orders => _firestore.collection('orders');

  // SERVICES CRUD
  Future<List<Map<String, dynamic>>> getServices() async {
    try {
      QuerySnapshot snapshot = await services.get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Get services error: $e');
      return [];
    }
  }

  Future<bool> addService(Map<String, dynamic> serviceData) async {
    try {
      await services.add({
        ...serviceData,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Add service error: $e');
      return false;
    }
  }

  // PRODUCTS CRUD
  Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      QuerySnapshot snapshot = await products.get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Get products error: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getProductsByCategory(String category) async {
    try {
      QuerySnapshot snapshot = await products
          .where('category', isEqualTo: category)
          .get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Get products by category error: $e');
      return [];
    }
  }

  Future<bool> addProduct(Map<String, dynamic> productData) async {
    try {
      await products.add({
        ...productData,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Add product error: $e');
      return false;
    }
  }

  // APPOINTMENTS CRUD
  Future<List<Map<String, dynamic>>> getUserAppointments(String userId) async {
    try {
      QuerySnapshot snapshot = await appointments
          .where('userId', isEqualTo: userId)
          .orderBy('appointmentDate', descending: true)
          .get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Get user appointments error: $e');
      return [];
    }
  }

  Future<bool> bookAppointment(Map<String, dynamic> appointmentData) async {
    try {
      await appointments.add({
        ...appointmentData,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Book appointment error: $e');
      return false;
    }
  }

  Future<bool> updateAppointmentStatus(String appointmentId, String status) async {
    try {
      await appointments.doc(appointmentId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Update appointment status error: $e');
      return false;
    }
  }

  // ORDERS CRUD
  Future<List<Map<String, dynamic>>> getUserOrders(String userId) async {
    try {
      QuerySnapshot snapshot = await orders
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Get user orders error: $e');
      return [];
    }
  }

  Future<bool> createOrder(Map<String, dynamic> orderData) async {
    try {
      await orders.add({
        ...orderData,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Create order error: $e');
      return false;
    }
  }

  Future<bool> updateOrderStatus(String orderId, String status) async {
    try {
      await orders.doc(orderId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Update order status error: $e');
      return false;
    }
  }

  // GENERAL CRUD OPERATIONS
  Future<bool> addDocument(String collection, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).add({
        ...data,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Add document error: $e');
      return false;
    }
  }

  Future<bool> updateDocument(String collection, String docId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(docId).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Update document error: $e');
      return false;
    }
  }

  Future<bool> deleteDocument(String collection, String docId) async {
    try {
      await _firestore.collection(collection).doc(docId).delete();
      return true;
    } catch (e) {
      print('Delete document error: $e');
      return false;
    }
  }

  // Stream for real-time updates
  Stream<QuerySnapshot> getCollectionStream(String collection) {
    return _firestore.collection(collection).snapshots();
  }

  Stream<DocumentSnapshot> getDocumentStream(String collection, String docId) {
    return _firestore.collection(collection).doc(docId).snapshots();
  }
}