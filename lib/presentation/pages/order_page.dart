import 'package:flutter/material.dart';
import 'package:flutter_developer_test/constants/app_assets.dart';
import 'package:flutter_developer_test/controllers/orders_controller.dart';
import 'package:flutter_developer_test/models/order.dart';
import 'package:flutter_developer_test/models/order_item.dart';
import 'package:flutter_developer_test/models/order_status.dart';
import 'package:flutter_developer_test/presentation/app_navigator.dart';
import 'package:flutter_developer_test/presentation/pages/bill_page.dart';
import 'package:flutter_developer_test/presentation/widgets/app_drawer.dart';
import 'package:flutter_developer_test/presentation/widgets/orders_table.dart';
import 'package:flutter_developer_test/theme/app_colors.dart';
import 'package:flutter_developer_test/utils/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OrderPage extends ConsumerStatefulWidget {
  const OrderPage({super.key});

  @override
  ConsumerState<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends ConsumerState<OrderPage> {
  final tableController = OrdersTableController();

  late final int orderId;

  @override
  void initState() {
    super.initState();
    orderId = Utils.getOrderId();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = buildAppBar(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      drawer: const AppDrawer(),
      body: OrdersTable(controller: tableController),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0.0,
      leading: Builder(builder: (context) {
        return IconButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: SvgPicture.asset(AppAssets.menu),
        );
      }),
      title: Image.asset(AppAssets.logo),
      bottom: PreferredSize(
        preferredSize: const Size(double.maxFinite, 40),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: clearAllFields,
                    icon: const Icon(Icons.close_rounded),
                  ),
                  IconButton(
                    onPressed: saveOrderToDatabase,
                    icon: SvgPicture.asset(AppAssets.arrowForward),
                  ),
                ],
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Order# ',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextSpan(
                      text: orderId.toString(),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  void saveOrderToDatabase() async {
    final rows = tableController.getFilledRows();

    // Empty rows or invalid data
    if (rows.isEmpty) return;

    for (final tuple in rows) {
      final (name, quantity, image, note) = tuple;
      if (name.isEmpty || quantity == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields.')),
        );
        return;
      }
    }

    final newOrder = Order(
      id: orderId,
      status: OrderStatus.pending,
      items: rows.map((tuple) {
        final (name, quantity, image, note) = tuple;
        return OrderItem(
          orderId: 0, // will be overwritten in DB insert
          productName: name,
          quantity: quantity,
          imagePath: image?.path,
        );
      }).toList(),
    );

    await ref.read(ordersProvider.notifier).addOrder(newOrder);

    if (mounted) {
      AppNavigator.slidePushRightToLeft(
        context,
        BillPage(orderId: orderId),
      );
    }
  }

  void clearAllFields() {
    tableController.clearAll();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order cleared.')),
    );
  }
}
