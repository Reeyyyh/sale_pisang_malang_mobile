import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentUser;
  Map<String, dynamic>? currentUserData;

  // Fungsi login dengan mengambil data pengguna yang login
  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      currentUser = userCredential.user;
      if (currentUser != null) {
        currentUserData = await getUserData(currentUser!.uid);
      }
      return currentUser;
    } catch (e) {
      throw Exception('Login Failed: $e');
    }
  }

  // Fungsi untuk mendapatkan data pengguna dari Firestore
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      return userDoc.exists ? userDoc.data() as Map<String, dynamic>? : null;
    } catch (e) {
      throw Exception('Error getting user data: $e');
    }
  }

  // Fungsi untuk inisialisasi user guest
  void initializeGuestUser() {
    currentUserData = {
      'name': 'Guest',
      'email': 'guest@gmail.com',
      'role': 'guest',
    };
    currentUser = null; // Tidak ada UID Firebase untuk guest
  }

  // Fungsi untuk logout
  Future<void> logout() async {
    try {
      await _auth.signOut();
      initializeGuestUser(); // Set kembali sebagai guest setelah logout
    } catch (e) {
      throw Exception('Logout Failed: $e');
    }
  }

  bool isUserLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
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
