import 'package:flutter/material.dart';
import 'package:flutter_developer_test/constants/app_assets.dart';
import 'package:flutter_developer_test/controllers/orders_controller.dart';
import 'package:flutter_developer_test/models/order_status.dart';
import 'package:flutter_developer_test/presentation/app_navigator.dart';
import 'package:flutter_developer_test/presentation/pages/bill_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);

    final savedOrders = orders.where((o) => o.status == OrderStatus.drafted).toList();
    final submittedOrders = orders.where((o) => o.status == OrderStatus.submitted).toList();

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Image.asset(
                  AppAssets.logo,
                  height: 120,
                ),
              ),
            ),

            const Divider(),

            // Saved Orders (Clickable)
            buildSectionTitle(context, 'Saved Orders'),
            ...savedOrders.map((order) => buildListTile(context, order.id)),

            const Divider(),

            // Submitted Orders (Not Clickable)
            buildSectionTitle(context, 'Submitted Orders'),
            ...submittedOrders.map((order) => buildListTile(context, order.id)),
          ],
        ),
      ),
    );
  }

  Widget buildListTile(BuildContext context, int orderId) {
    return ListTile(
      title: Text('Order# $orderId'),
      onTap: () {
        Navigator.of(context).pop(); // Close drawer
        AppNavigator.slidePushRightToLeft(
          context,
          BillPage(orderId: orderId),
        );
      },
    );
  }

  Widget buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
