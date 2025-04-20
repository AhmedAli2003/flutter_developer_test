import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_developer_test/constants/app_assets.dart';
import 'package:flutter_developer_test/controllers/order_by_id_provider.dart';
import 'package:flutter_developer_test/controllers/orders_controller.dart';
import 'package:flutter_developer_test/models/order_status.dart';
import 'package:flutter_developer_test/presentation/app_navigator.dart';
import 'package:flutter_developer_test/presentation/pages/order_page.dart';
import 'package:flutter_developer_test/presentation/widgets/order_detail_row.dart';
import 'package:flutter_developer_test/presentation/widgets/submit_button.dart';
import 'package:flutter_developer_test/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BillPage extends ConsumerWidget {
  const BillPage({super.key, required this.orderId});

  final int orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncOrder = ref.watch(orderByIdProvider(orderId));

    final appBar = buildAppBar(context, ref);

    const gap = SizedBox(height: 16);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: asyncOrder.when(
        data: (order) {
          if (order == null) {
            return const Center(child: Text('Order not found.'));
          }

          final totalQuantities = order.items.map((i) => i.quantity).reduce((s, p) => s + p);

          final randomPrice = (totalQuantities * (Random().nextDouble() + 10)).toStringAsFixed(2);

          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 200, 24, 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OrderDetailRow(label: 'Order #', value: orderId.toString()),
                  gap,
                  const OrderDetailRow(
                    label: 'Order name',
                    value: 'Joe’s catering',
                    optional: true,
                  ),
                  gap,
                  const OrderDetailRow(label: 'Delivery date', value: 'May 4th 2024'),
                  gap,
                  OrderDetailRow(
                    label: 'Total quantity',
                    value: totalQuantities.toString(),
                    valueTextStyle: Theme.of(context).textTheme.bodyLarge,
                  ),
                  gap,
                  OrderDetailRow(
                    label: 'Estimated total',
                    value: '\$$randomPrice',
                    valueTextStyle: Theme.of(context).textTheme.bodyLarge,
                  ),
                  gap,
                  SizedBox(
                    height: 74,
                    child: OrderDetailRow(
                      label: 'Location',
                      value: "355 Onderdonk St\nMarina Dubai, UAE",
                      location: true,
                      valueTextStyle: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  gap,
                  Text(
                    'Delivery instructions...',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: AppColors.primary,
                        ),
                  ),
                  gap,
                  SubmitButton(
                    // Only clickable if the order is not already submitted
                    onPressed: order.status != OrderStatus.submitted ? () => submitOrder(context, ref) : null,
                    text: 'Submit',
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    // Only clickable if the order is not already saved or submitted
                    onTap: order.status == OrderStatus.pending ? () => saveOrder(context, ref) : null,
                    child: Text(
                      'Save as draft',
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            color: order.status == OrderStatus.pending ? AppColors.primary : AppColors.greyText,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      scrolledUnderElevation: 0.0,
      automaticallyImplyLeading: false,
      title: Image.asset(AppAssets.logo),
      bottom: PreferredSize(
        preferredSize: const Size(double.maxFinite, 20),
        child: Align(
          alignment: const Alignment(-0.9, -1.0),
          child: IconButton(
            onPressed: () => back(context, ref),
            icon: SvgPicture.asset(AppAssets.arrowBack),
          ),
        ),
      ),
    );
  }

  void back(BuildContext context, WidgetRef ref) async {
    final order = await ref.read(ordersProvider.notifier).getOrderById(orderId);

    // Delete the order if it NOT saved or submitted
    if (order != null && order.status == OrderStatus.pending) {
      ref.read(ordersProvider.notifier).deleteOrder(orderId);
    }

    // Navigate to Orders Page
    if (context.mounted) Navigator.of(context).pop();
  }

  void saveOrder(BuildContext context, WidgetRef ref) async {
    // Save the order as draft
    await ref.read(ordersProvider.notifier).updateStatus(orderId, OrderStatus.drafted);

    ref.read(orderByIdProvider(orderId));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The order is saved successfully!')),
      );
    }
  }

  void submitOrder(BuildContext context, WidgetRef ref) async {
    await ref.read(ordersProvider.notifier).updateStatus(orderId, OrderStatus.submitted);

    // Navigate to Orders Page
    if (context.mounted)
      AppNavigator.slidePushReplacementLeftToRight(
        context,
        const OrderPage(),
      );
  }
}
