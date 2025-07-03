import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_crm/core/controllers/auth_controller.dart';

class NavigationItem {
  final String title;
  final String route;
  final IconData icon;
  final List<UserRole> allowedRoles;

  NavigationItem({
    required this.title,
    required this.route,
    required this.icon,
    required this.allowedRoles,
  });
}

class NavigationController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  final RxBool isDrawerOpen = false.obs;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final List<NavigationItem> navigationItems = [
    NavigationItem(
      title: 'Dashboard',
      route: '/dashboard',
      icon: Icons.dashboard,
      allowedRoles: UserRole.values,
    ),
    NavigationItem(
      title: 'Users',
      route: '/users',
      icon: Icons.people,
      allowedRoles: [UserRole.admin],
    ),
    NavigationItem(
      title: 'Lead Sources',
      route: '/lead-sources',
      icon: Icons.source,
      allowedRoles: [UserRole.admin, UserRole.manager],
    ),
    NavigationItem(
      title: 'Customers',
      route: '/customers',
      icon: Icons.person,
      allowedRoles: UserRole.values,
    ),
    NavigationItem(
      title: 'Destinations',
      route: '/destinations',
      icon: Icons.place,
      allowedRoles: UserRole.values,
    ),
    NavigationItem(
      title: 'Packages',
      route: '/packages',
      icon: Icons.card_travel,
      allowedRoles: UserRole.values,
    ),
    NavigationItem(
      title: 'Vendors',
      route: '/vendors',
      icon: Icons.store,
      allowedRoles: [UserRole.admin, UserRole.manager, UserRole.teamLeader],
    ),
    NavigationItem(
      title: 'Expenses',
      route: '/expenses',
      icon: Icons.receipt_long,
      allowedRoles: UserRole.values,
    ),
    NavigationItem(
      title: 'Bookings',
      route: '/bookings',
      icon: Icons.book_online,
      allowedRoles: UserRole.values,
    ),
    NavigationItem(
      title: 'Tasks',
      route: '/tasks',
      icon: Icons.task,
      allowedRoles: UserRole.values,
    ),
    NavigationItem(
      title: 'Reports',
      route: '/reports',
      icon: Icons.bar_chart,
      allowedRoles: [UserRole.admin, UserRole.manager],
    ),
  ];

  List<NavigationItem> get authorizedItems {
    final authController = Get.find<AuthController>();
    return navigationItems.where((item) => 
      authController.hasPermission(item.allowedRoles)
    ).toList();
  }

  void toggleDrawer() {
    if (scaffoldKey.currentState?.isDrawerOpen ?? false) {
      scaffoldKey.currentState?.closeDrawer();
    } else {
      scaffoldKey.currentState?.openDrawer();
    }
  }

  void selectItem(int index) {
    selectedIndex.value = index;
    Get.toNamed(authorizedItems[index].route);
    
    // Close drawer on mobile after selection
    if (Get.width < 1200 && (scaffoldKey.currentState?.isDrawerOpen ?? false)) {
      scaffoldKey.currentState?.closeDrawer();
    }
  }

  bool isSelected(int index) => selectedIndex.value == index;

  // Helper method to determine if we should show drawer or sidebar
  bool get shouldShowDrawer => Get.width < 1200;
}
