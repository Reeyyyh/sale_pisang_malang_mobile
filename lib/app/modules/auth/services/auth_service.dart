import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fungsi login
  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception('Login Failed: $e');
    }
  }

  // Fungsi untuk mendapatkan data pengguna dari Firestore
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>?;
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Error getting user data: $e');
    }
  }

  // Fungsi untuk melakukan logout
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Logout Failed: $e');
    }
  }

  // Fungsi untuk melakukan registrasi pengguna baru
  Future<User?> register(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      String uid = userCredential.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'role': email == 'adminpage@gmail.com' ? 'admin' : 'user',
      });

      return userCredential.user;
    } catch (e) {
      throw Exception('Registration Failed: $e');
    }
  }
}
