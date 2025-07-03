import 'package:get/get.dart';
import 'package:travel_crm/core/middleware/auth_middleware.dart';
import 'package:travel_crm/modules/auth/views/login_view.dart';
import 'package:travel_crm/modules/dashboard/views/dashboard_view.dart';
import 'package:travel_crm/modules/users/views/users_view.dart';
import 'package:travel_crm/modules/customers/views/customers_view.dart';
import 'package:travel_crm/modules/destinations/views/destinations_view.dart';
import 'package:travel_crm/modules/packages/views/packages_view.dart';
import 'package:travel_crm/modules/vendors/views/vendors_view.dart';
import 'package:travel_crm/modules/expenses/views/expenses_view.dart';
import 'package:travel_crm/modules/bookings/views/bookings_view.dart';
import 'package:travel_crm/modules/tasks/views/tasks_view.dart';
import 'package:travel_crm/modules/reports/views/reports_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      middlewares: [
        NoAuthMiddleware(), // Redirect to home if already authenticated
      ],
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => DashboardView(),
      middlewares: [
        AuthMiddleware(), // Ensure user is authenticated
      ],
    ),
    GetPage(
      name: Routes.USERS,
      page: () => UsersView(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware([UserRole.admin]), // Only admin can access
      ],
    ),
    GetPage(
      name: Routes.CUSTOMERS,
      page: () => CustomersView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.DESTINATIONS,
      page: () => DestinationsView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.PACKAGES,
      page: () => PackagesView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.VENDORS,
      page: () => VendorsView(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware([
          UserRole.admin,
          UserRole.manager,
          UserRole.teamLeader,
        ]),
      ],
    ),
    GetPage(
      name: Routes.EXPENSES,
      page: () => ExpensesView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.BOOKINGS,
      page: () => BookingsView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.TASKS,
      page: () => TasksView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.REPORTS,
      page: () => ReportsView(),
      middlewares: [
        AuthMiddleware(),
        RoleMiddleware([UserRole.admin, UserRole.manager]),
      ],
    ),
  ];
}
