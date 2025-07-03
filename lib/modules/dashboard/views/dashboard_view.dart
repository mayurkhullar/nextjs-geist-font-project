import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_crm/core/widgets/base_layout.dart';
import 'package:travel_crm/core/theme/app_colors.dart';
import 'package:travel_crm/modules/dashboard/controllers/dashboard_controller.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    return BaseLayout(
      title: 'Dashboard',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI Cards
            GridView.count(
              crossAxisCount: _getGridCount(context),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildKpiCard(
                  context,
                  'New Leads',
                  controller.newLeadsCount,
                  Icons.person_add,
                  AppColors.info,
                ),
                _buildKpiCard(
                  context,
                  'Converted Leads',
                  controller.convertedLeadsCount,
                  Icons.check_circle,
                  AppColors.success,
                ),
                _buildKpiCard(
                  context,
                  'Revenue',
                  controller.totalRevenue,
                  Icons.currency_rupee,
                  AppColors.accent,
                  isAmount: true,
                ),
                _buildKpiCard(
                  context,
                  'Pending Payments',
                  controller.pendingPayments,
                  Icons.payment,
                  AppColors.warning,
                  isAmount: true,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Recent Tasks
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Tasks',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        TextButton.icon(
                          onPressed: () => Get.toNamed('/tasks'),
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('View All'),
                        ),
                      ],
                    ),
                    const Divider(),
                    Obx(() => controller.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.recentTasks.length,
                            itemBuilder: (context, index) {
                              final task = controller.recentTasks[index];
                              return ListTile(
                                leading: const Icon(Icons.task),
                                title: Text(task.title),
                                subtitle: Text(task.dueDate),
                                trailing: _buildStatusChip(task.status),
                              );
                            },
                          )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Recent Bookings
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Bookings',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        TextButton.icon(
                          onPressed: () => Get.toNamed('/bookings'),
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('View All'),
                        ),
                      ],
                    ),
                    const Divider(),
                    Obx(() => controller.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.recentBookings.length,
                            itemBuilder: (context, index) {
                              final booking = controller.recentBookings[index];
                              return ListTile(
                                leading: const Icon(Icons.book_online),
                                title: Text(booking.customerName),
                                subtitle: Text(booking.destination),
                                trailing: Text(
                                  '₹${booking.amount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard(
    BuildContext context,
    String title,
    RxDouble value,
    IconData icon,
    Color color, {
    bool isAmount = false,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Obx(() => Text(
                  isAmount
                      ? '₹${value.value.toStringAsFixed(2)}'
                      : value.value.toStringAsFixed(0),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'pending':
        color = AppColors.warning;
        break;
      case 'completed':
        color = AppColors.success;
        break;
      case 'overdue':
        color = AppColors.error;
        break;
      default:
        color = AppColors.info;
    }

    return Chip(
      label: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
      backgroundColor: color,
    );
  }

  int _getGridCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 2;
    return 1;
  }
}
