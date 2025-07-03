import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_crm/core/controllers/auth_controller.dart';
import 'package:travel_crm/routes/app_pages.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    
    // If user is not logged in, redirect to login
    if (authController.firebaseUser.value == null) {
      return const RouteSettings(name: Routes.LOGIN);
    }
    
    return null;
  }
}

class NoAuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    
    // If user is logged in, redirect to dashboard
    if (authController.firebaseUser.value != null) {
      return const RouteSettings(name: Routes.DASHBOARD);
    }
    
    return null;
  }
}

class RoleMiddleware extends GetMiddleware {
  final List<UserRole> allowedRoles;

  RoleMiddleware(this.allowedRoles);

  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    
    // If user's role is not in allowed roles, redirect to dashboard
    if (!authController.hasPermission(allowedRoles)) {
      Get.snackbar(
        'Access Denied',
        'You do not have permission to access this page',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return const RouteSettings(name: Routes.DASHBOARD);
    }
    
    return null;
  }
}

class CustomerAccessMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    final customerId = Get.parameters['id'];
    
    if (customerId != null && !authController.canAccessCustomer(customerId)) {
      Get.snackbar(
        'Access Denied',
        'You do not have permission to access this customer',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return const RouteSettings(name: Routes.CUSTOMERS);
    }
    
    return null;
  }
}
