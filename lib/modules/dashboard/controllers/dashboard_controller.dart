import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_crm/core/controllers/auth_controller.dart';

class DashboardTask {
  final String title;
  final String dueDate;
  final String status;

  DashboardTask({
    required this.title,
    required this.dueDate,
    required this.status,
  });

  factory DashboardTask.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DashboardTask(
      title: data['title'] ?? '',
      dueDate: data['dueDate'] ?? '',
      status: data['status'] ?? 'pending',
    );
  }
}

class DashboardBooking {
  final String customerName;
  final String destination;
  final double amount;

  DashboardBooking({
    required this.customerName,
    required this.destination,
    required this.amount,
  });

  factory DashboardBooking.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DashboardBooking(
      customerName: data['customerName'] ?? '',
      destination: data['destination'] ?? '',
      amount: (data['salePrice'] ?? 0.0).toDouble(),
    );
  }
}

class DashboardController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController _authController = Get.find<AuthController>();

  final isLoading = true.obs;
  
  // KPI Metrics
  final newLeadsCount = 0.0.obs;
  final convertedLeadsCount = 0.0.obs;
  final totalRevenue = 0.0.obs;
  final pendingPayments = 0.0.obs;

  // Recent Items
  final recentTasks = <DashboardTask>[].obs;
  final recentBookings = <DashboardBooking>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      isLoading.value = true;

      // Load KPI data based on user role
      await Future.wait([
        _loadLeadsData(),
        _loadRevenueData(),
        _loadTasksData(),
        _loadBookingsData(),
      ]);

    } catch (e) {
      print('Error loading dashboard data: $e');
      Get.snackbar(
        'Error',
        'Failed to load dashboard data',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadLeadsData() async {
    final query = _firestore.collection('customers');
    final QuerySnapshot snapshot;

    // Filter based on user role and assigned IDs
    if (_authController.userModel.value?.role == UserRole.salesAgent) {
      snapshot = await query
          .where('assignedToIds', arrayContains: _authController.userModel.value?.id)
          .get();
    } else {
      snapshot = await query.get();
    }

    // Count new leads (created in last 30 days)
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    newLeadsCount.value = snapshot.docs
        .where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final createdAt = (data['createdAt'] as Timestamp).toDate();
          return createdAt.isAfter(thirtyDaysAgo);
        })
        .length
        .toDouble();

    // Count converted leads
    convertedLeadsCount.value = snapshot.docs
        .where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return data['status'] == 'Converted';
        })
        .length
        .toDouble();
  }

  Future<void> _loadRevenueData() async {
    final bookingsQuery = _firestore.collection('bookings');
    final QuerySnapshot bookingsSnapshot;

    if (_authController.userModel.value?.role == UserRole.salesAgent) {
      bookingsSnapshot = await bookingsQuery
          .where('createdBy', isEqualTo: _authController.userModel.value?.id)
          .get();
    } else {
      bookingsSnapshot = await bookingsQuery.get();
    }

    double revenue = 0;
    double pending = 0;

    for (var doc in bookingsSnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final salePrice = (data['salePrice'] ?? 0.0).toDouble();
      final paidAmount = (data['paidAmount'] ?? 0.0).toDouble();

      revenue += salePrice;
      pending += (salePrice - paidAmount);
    }

    totalRevenue.value = revenue;
    pendingPayments.value = pending;
  }

  Future<void> _loadTasksData() async {
    final query = _firestore.collection('tasks')
        .where('assignedTo', isEqualTo: _authController.userModel.value?.id)
        .orderBy('dueDate', descending: true)
        .limit(5);

    final snapshot = await query.get();
    recentTasks.value = snapshot.docs
        .map((doc) => DashboardTask.fromFirestore(doc))
        .toList();
  }

  Future<void> _loadBookingsData() async {
    final query = _firestore.collection('bookings')
        .orderBy('createdAt', descending: true)
        .limit(5);

    final QuerySnapshot snapshot;
    if (_authController.userModel.value?.role == UserRole.salesAgent) {
      snapshot = await query
          .where('createdBy', isEqualTo: _authController.userModel.value?.id)
          .get();
    } else {
      snapshot = await query.get();
    }

    recentBookings.value = snapshot.docs
        .map((doc) => DashboardBooking.fromFirestore(doc))
        .toList();
  }

  void refreshDashboard() {
    _loadDashboardData();
  }
}
