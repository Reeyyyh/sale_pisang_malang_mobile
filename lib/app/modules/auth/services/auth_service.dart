import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/modules/Page/1_Home/controllers/home_page_controller.dart';
import 'package:sale_pisang_malang/app/modules/Page/2_MyOrder/controllers/cart_page_controller.dart';
import 'package:sale_pisang_malang/app/modules/Page/3_Favorite/controllers/favorite_page_controller.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? currentUser;
  Map<String, dynamic>? currentUserData;

  AuthService() {
    initializeUser();
  }

  Future<void> initializeUser() async {
    User? user = _auth.currentUser;
    if (user == null) {
      print('User is currently signed out!');
      initializeGuestUser();
    } else {
      print('User is signed in!');
      currentUser = user;
      currentUserData = await getUserData(currentUser!.uid);
    }
    // Panggil fungsi update dari luar controller, bukan di sini.
    updateControllersStatus();
  }

  void updateControllersStatus() {
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().checkUserStatus();
    }
    if (Get.isRegistered<FavoriteController>()) {
      Get.find<FavoriteController>().checkUserStatus();
    }
    if (Get.isRegistered<CartPageController>()) {
      Get.find<CartPageController>().checkUserStatus();
    }
  }

  // fungsi auth login
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
      Get.find<HomeController>().checkUserStatus();
      Get.find<FavoriteController>().checkUserStatus();
      Get.find<CartPageController>().checkUserStatus();
      return currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('Email tidak terdaftar');
      } else if (e.code == 'wrong-password') {
        throw Exception('Password salah');
      } else {
        throw Exception('Login Gagal: ${e.message}');
      }
    }
  }

  // fungsi auth register
  Future<User?> register(String name, String email, String password) async {
    try {
      // Mendaftarkan pengguna baru
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid; // Ambil UID pengguna baru

      // Simpan data pengguna ke Firestore
      await _firestore.collection('users').doc(uid).set({
        'id': uid, // Tambahkan UID
        'name': name,
        'email': email,
        'role': 'user',
      });

      // Perbarui currentUser dan currentUserData
      currentUser = userCredential.user;
      currentUserData = {
        'id': uid,
        'name': name,
        'email': email,
        'role': 'user'
      };

      // Perbarui kontroler setelah registrasi
      _updateControllersStatus();

      return currentUser;
    } on FirebaseAuthException catch (e) {
      // Tangani error Firebase Authentication
      if (e.code == 'email-already-in-use') {
        throw Exception('Email sudah terdaftar');
      } else if (e.code == 'weak-password') {
        throw Exception('Password terlalu lemah');
      } else {
        throw Exception('Registrasi gagal: ${e.message}');
      }
    } catch (e) {
      // Tangani error lainnya
      throw Exception('Registrasi gagal: $e');
    }
  }

  void _updateControllersStatus() {
    // Memastikan kontroler hanya diakses jika sudah terdaftar di GetX
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().checkUserStatus();
    }
    if (Get.isRegistered<FavoriteController>()) {
      Get.find<FavoriteController>().checkUserStatus();
    }
    if (Get.isRegistered<CartPageController>()) {
      Get.find<CartPageController>().checkUserStatus();
    }
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      return userDoc.exists ? userDoc.data() as Map<String, dynamic>? : null;
    } catch (e) {
      throw Exception('Error getting user data: $e');
    }
  }

  void initializeGuestUser() {
    currentUserData = {
      'name': 'Guest',
      'email': 'guest@gmail.com',
      'role': 'guest',
    };
    currentUser = null;
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      initializeGuestUser();
      // Memperbarui kontroler setelah logout
      Get.find<HomeController>().checkUserStatus();
      Get.find<FavoriteController>().checkUserStatus();
      Get.find<CartPageController>().checkUserStatus();
    } catch (e) {
      throw Exception('Logout Failed: $e');
    }
  }

  bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }

  void checkUserStatus() {
    if (isUserLoggedIn()) {
      currentUser = _auth.currentUser;
      print('User status: Logged in');
    } else {
      initializeGuestUser();
      print('User status: Guest');
    }
  }
}
