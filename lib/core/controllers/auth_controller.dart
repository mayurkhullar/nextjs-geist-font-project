import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:travel_crm/routes/app_pages.dart';

enum UserRole { admin, manager, teamLeader, salesAgent }

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final List<String> assignedIds;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.assignedIds,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${data['role']}',
        orElse: () => UserRole.salesAgent,
      ),
      assignedIds: List<String>.from(data['assignedIds'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'role': role.toString().split('.').last,
      'assignedIds': assignedIds,
    };
  }
}

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  final Rx<User?> firebaseUser = Rx<User?>(null);
  final Rx<UserModel?> userModel = Rx<UserModel?>(null);
  
  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  void _setInitialScreen(User? user) async {
    if (user == null) {
      Get.offAllNamed(Routes.LOGIN);
    } else {
      await _fetchUserData(user.uid);
      Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> _fetchUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        userModel.value = UserModel.fromFirestore(doc);
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Sign in failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      userModel.value = null;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Sign out failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  bool hasPermission(List<UserRole> allowedRoles) {
    if (userModel.value == null) return false;
    return allowedRoles.contains(userModel.value!.role);
  }

  bool canAccessCustomer(String customerId) {
    if (userModel.value == null) return false;
    
    switch (userModel.value!.role) {
      case UserRole.admin:
      case UserRole.manager:
        return true;
      case UserRole.teamLeader:
      case UserRole.salesAgent:
        return userModel.value!.assignedIds.contains(customerId);
    }
  }
}
