import 'dart:math';
import 'package:flutter/material.dart';
import '../models/expense_item.dart';
import '../theme/app_theme.dart';
import 'add_item_sheet.dart';
import 'expense_tile.dart';

/// The single list a person keeps for their own trip. This is the whole
/// app — one device, one list, no sharing.
class ExpenseList extends StatefulWidget {
  const ExpenseList({super.key});

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  final List<ExpenseItem> _items = [];
  final _idSeed = Random();
  String _title = 'My list';

  double get _subtotal =>
      _items.fold(0.0, (sum, item) => sum + item.lineTotal);

  Future<void> _addItem() async {
    final result = await showAddItemSheet(context);
    if (result == null) return;
    setState(() {
      _items.add(
        ExpenseItem(
          id: '${DateTime.now().microsecondsSinceEpoch}-${_idSeed.nextInt(9999)}',
          name: result.name,
          unitPrice: result.unitPrice,
        ),
      );
    });
  }

  void _updateQuantity(ExpenseItem item, int quantity) {
    setState(() => item.quantity = quantity);
  }

  void _removeItem(ExpenseItem item) {
    setState(() => _items.remove(item));
  }

  void _clearList() {
    setState(_items.clear);
  }

  Future<void> _editTitle() async {
    final controller = TextEditingController(text: _title);
    final newTitle = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Rename this list'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(labelText: 'List name'),
          onSubmitted: (value) => Navigator.of(context).pop(value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            style: FilledButton.styleFrom(backgroundColor: AppColors.sage),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (newTitle != null && newTitle.trim().isNotEmpty) {
      setState(() => _title = newTitle.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _editTitle,
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              _title,
                              style: Theme.of(context).appBarTheme.titleTextStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 7),
                          const Icon(
                            Icons.edit_outlined,
                            size: 14,
                            color: AppColors.inkFaint,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    '${_items.length} item${_items.length == 1 ? '' : 's'}',
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Expanded(
              child: _items.isEmpty
                  ? const _EmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return ExpenseTile(
                          item: item,
                          onQuantityChanged: (qty) =>
                              _updateQuantity(item, qty),
                          onDismissed: () => _removeItem(item),
                        );
                      },
                    ),
            ),
            _SubtotalBar(subtotal: _subtotal),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'clear-list',
            onPressed: _clearList,
            backgroundColor: AppColors.terracotta,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.delete_sweep_outlined),
            label: const Text('Clear list'),
          ),
          const SizedBox(width: 12),
          FloatingActionButton.extended(
            heroTag: 'add-item',
            onPressed: _addItem,
            backgroundColor: AppColors.sage,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add item'),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_basket_outlined,
              size: 38,
              color: AppColors.sage.withAlpha(140),
            ),
            const SizedBox(height: 14),
            Text('No items yet', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              'Tap "Add item" to start tallying as you shop.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _SubtotalBar extends StatelessWidget {
  const _SubtotalBar({required this.subtotal});

  final double subtotal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Extra bottom room so the floating "Add item" button (which overlaps
      // body content rather than pushing it up) doesn't cover the figure.
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 84),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Sub-total', style: Theme.of(context).textTheme.bodyMedium),
            Text(
              '\$${subtotal.toStringAsFixed(2)}',
              style: AppTheme.subtotalStyle(color: AppColors.sageDeep),
            ),
          ],
        ),
      ),
    );
  }
}
