import 'package:flutter/material.dart';
import 'package:flutter_developer_test/presentation/pages/order_page.dart';
import 'package:flutter_developer_test/theme/app_theme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Developer Test',
      theme: AppTheme.theme,
      home: const OrderPage(),
    );
  }
}
