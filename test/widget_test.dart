import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prereceipt/main.dart';

void main() {
  Future<void> addItem(
    WidgetTester tester, {
    required String name,
    required String price,
  }) async {
    await tester.tap(find.text('Add item'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), name);
    await tester.enterText(find.byType(TextFormField).at(1), price);
    await tester.tap(find.text('Add to list'));
    await tester.pumpAndSettle();
  }

  testWidgets('adds items and recalculates the subtotal',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PreReceiptApp());

    await addItem(tester, name: 'Apples', price: '2.50');
    expect(find.text('Apples'), findsOneWidget);
    expect(find.text(r'$2.50'), findsNWidgets(2));

    await tester.tap(find.byIcon(Icons.add_rounded).first);
    await tester.pump();
    expect(find.text(r'$5.00'), findsOneWidget);
  });

  testWidgets('removes an individual item', (WidgetTester tester) async {
    await tester.pumpWidget(const PreReceiptApp());
    await addItem(tester, name: 'Apples', price: '2.50');

    await tester.tap(find.byTooltip('Remove Apples'));
    await tester.pumpAndSettle();

    expect(find.text('No items yet'), findsOneWidget);
    expect(find.text(r'$0.00'), findsOneWidget);
  });

  testWidgets('clears the list', (WidgetTester tester) async {
    await tester.pumpWidget(const PreReceiptApp());
    await addItem(tester, name: 'Apples', price: '2.50');
    await addItem(tester, name: 'Bread', price: '3.00');

    await tester.tap(find.text('Clear list'));
    await tester.pumpAndSettle();

    expect(find.text('No items yet'), findsOneWidget);
    expect(find.text(r'$0.00'), findsOneWidget);
  });
}
