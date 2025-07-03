part of 'app_pages.dart';

abstract class Routes {
  static const LOGIN = '/login';
  static const DASHBOARD = '/dashboard';
  static const USERS = '/users';
  static const CUSTOMERS = '/customers';
  static const DESTINATIONS = '/destinations';
  static const PACKAGES = '/packages';
  static const VENDORS = '/vendors';
  static const EXPENSES = '/expenses';
  static const BOOKINGS = '/bookings';
  static const TASKS = '/tasks';
  static const REPORTS = '/reports';
  
  // Detail routes
  static const CUSTOMER_DETAIL = '/customers/:id';
  static const DESTINATION_DETAIL = '/destinations/:id';
  static const PACKAGE_DETAIL = '/packages/:id';
  static const BOOKING_DETAIL = '/bookings/:id';
  static const VENDOR_DETAIL = '/vendors/:id';
  static const EXPENSE_DETAIL = '/expenses/:id';
  static const TASK_DETAIL = '/tasks/:id';
  
  // Create routes
  static const CUSTOMER_CREATE = '/customers/create';
  static const DESTINATION_CREATE = '/destinations/create';
  static const PACKAGE_CREATE = '/packages/create';
  static const BOOKING_CREATE = '/bookings/create';
  static const VENDOR_CREATE = '/vendors/create';
  static const EXPENSE_CREATE = '/expenses/create';
  static const TASK_CREATE = '/tasks/create';
  
  // Report routes
  static const REPORT_KPI = '/reports/kpi';
  static const REPORT_PROFIT = '/reports/profit';
  static const REPORT_LEADERBOARD = '/reports/leaderboard';
  static const REPORT_ACCOUNTANT = '/reports/accountant';
}
