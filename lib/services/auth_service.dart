import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<Map<String, dynamic>> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return {'success': true, 'user': result, 'message': 'Giriş başarılı'};
    } catch (e) {
      print('Sign in error: $e');
      String errorMessage = 'Giriş başarısız';
      
      if (e.toString().contains('user-not-found')) {
        errorMessage = 'Bu email adresi ile kayıtlı kullanıcı bulunamadı';
      } else if (e.toString().contains('wrong-password')) {
        errorMessage = 'Yanlış şifre';
      } else if (e.toString().contains('invalid-email')) {
        errorMessage = 'Geçersiz email adresi';
      } else if (e.toString().contains('user-disabled')) {
        errorMessage = 'Bu hesap devre dışı bırakılmış';
      } else if (e.toString().contains('network-request-failed')) {
        errorMessage = 'İnternet bağlantı sorunu';
      }
      
      return {'success': false, 'user': null, 'message': errorMessage};
    }
  }

  // Register with email and password
  Future<Map<String, dynamic>> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
    String phone,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;
      if (user != null) {
        // Update display name
        await user.updateDisplayName(name);
        
        // Create user document in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'name': name,
          'phone': phone,
          'createdAt': FieldValue.serverTimestamp(),
          'role': 'customer',
        });
      }

      return {'success': true, 'user': result, 'message': 'Kayıt başarılı'};
    } catch (e) {
      print('Registration error: $e');
      String errorMessage = 'Kayıt başarısız';
      
      if (e.toString().contains('email-already-in-use')) {
        errorMessage = 'Bu email adresi zaten kullanımda';
      } else if (e.toString().contains('weak-password')) {
        errorMessage = 'Şifre çok zayıf (en az 6 karakter)';
      } else if (e.toString().contains('invalid-email')) {
        errorMessage = 'Geçersiz email adresi';
      } else if (e.toString().contains('network-request-failed')) {
        errorMessage = 'İnternet bağlantı sorunu';
      }
      
      return {'success': false, 'user': null, 'message': errorMessage};
    }
  }

  // Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print('Password reset error: $e');
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  // Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      User? user = currentUser;
      if (user != null) {
        DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      print('Get user data error: $e');
      return null;
    }
  }

  // Update user profile
  Future<bool> updateUserProfile(Map<String, dynamic> data) async {
    try {
      User? user = currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update(data);
        
        // Update display name if provided
        if (data['name'] != null) {
          await user.updateDisplayName(data['name']);
        }
        
        return true;
      }
      return false;
    } catch (e) {
      print('Update profile error: $e');
      return false;
    }
  }
}