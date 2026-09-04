import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'widgets/expense_list.dart';

void main() {
  runApp(const PreReceiptApp());
}

class PreReceiptApp extends StatelessWidget {
  const PreReceiptApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PreReceipt',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const ExpenseList(),
    );
  }
}
