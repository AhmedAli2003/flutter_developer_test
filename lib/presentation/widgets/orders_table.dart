import 'package:flutter/material.dart';
import 'package:flutter_developer_test/controllers/suggestions_provider.dart';
import 'package:flutter_developer_test/presentation/widgets/modal_sheet_widget.dart';
import 'package:flutter_developer_test/presentation/widgets/order_row.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class OrdersTable extends ConsumerStatefulWidget {
  const OrdersTable({super.key, required this.controller});

  final OrdersTableController? controller;

  @override
  ConsumerState<OrdersTable> createState() => _OrdersTableState();
}

class _OrdersTableState extends ConsumerState<OrdersTable> {
  int rowCount = 20;

  late List<TextEditingController> productsControllers;
  late List<FocusNode> productsFocusNodes;
  late List<TextEditingController> quantityControllers;
  late List<FocusNode> quantityFocusNodes;

  late List<String?> notes;
  late List<XFile?> images;

  @override
  void initState() {
    super.initState();
    productsControllers = [];
    productsFocusNodes = [];
    quantityControllers = [];
    quantityFocusNodes = [];
    notes = [];
    images = [];

    _initRows(rowCount);
    widget.controller?._attach(this);
  }

  void _initRows(int count) {
    for (int i = productsControllers.length; i < count; i++) {
      final pController = TextEditingController();
      final qController = TextEditingController();

      pController.addListener(() => _checkToAddMoreRows(i));
      qController.addListener(() => _checkToAddMoreRows(i));

      productsControllers.add(pController);
      quantityControllers.add(qController);
      productsFocusNodes.add(FocusNode());
      quantityFocusNodes.add(FocusNode());
      notes.add(null);
      images.add(null);
    }
    rowCount = productsControllers.length;
  }

  void _checkToAddMoreRows(int index) {
    // If user filled the last row, add 10 more rows
    if (index == productsControllers.length - 1) {
      final name = productsControllers[index].text.trim();
      final quantity = quantityControllers[index].text.trim();

      if (name.isNotEmpty && quantity.isNotEmpty) {
        setState(() {
          _initRows(productsControllers.length + 10);
        });
      }
    }
  }

  @override
  void dispose() {
    for (final c in productsControllers) c.dispose();
    for (final f in productsFocusNodes) f.dispose();
    for (final c in quantityControllers) c.dispose();
    for (final f in quantityFocusNodes) f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productSuggestions = ref.watch(productSuggestionsProvider).maybeWhen(
          data: (products) => products,
          orElse: () => <String>[],
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: ListView.builder(
        itemCount: rowCount,
        itemBuilder: (context, index) => GestureDetector(
          onDoubleTap: () => handleLongPressAndDoubleTap(index),
          onLongPress: () => handleLongPressAndDoubleTap(index),
          child: OrderRow(
            hasImage: images[index] != null,
            hasNote: notes[index] != null,
            productController: productsControllers[index],
            productFocusNode: productsFocusNodes[index],
            quantityController: quantityControllers[index],
            quantityFocusNode: quantityFocusNodes[index],
            onTap: () => handleFocus(index),
            suggestions: productSuggestions,
          ),
        ),
      ),
    );
  }

  void handleFocus(int index) {
    for (int i = 0; i < index; i++) {
      if (productsControllers[i].text.trim().isEmpty || quantityControllers[i].text.trim().isEmpty) {
        if (quantityControllers[i].text.trim().isEmpty) {
          FocusScope.of(context).requestFocus(quantityFocusNodes[i]);
        } else {
          FocusScope.of(context).requestFocus(productsFocusNodes[i]);
        }
        return;
      }
    }
  }

  void handleLongPressAndDoubleTap(int index) {
    if (productsControllers[index].text.trim().isNotEmpty) {
      openNoteModal(index);
    }
  }

  void openNoteModal(int index) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ModalSheetWidget(
        notes: notes,
        images: images,
        index: index,
        onEnd: () => setState(() {}),
      ),
    );
  }

  List<(String name, int quantity, XFile? image, String? note)> getFilledRows(BuildContext context) {
    final result = <(String, int, XFile?, String?)>[];

    for (int i = 0; i < rowCount; i++) {
      final name = productsControllers[i].text.trim();
      final quantityText = quantityControllers[i].text.trim();

      if (i == 0 && name.isEmpty && quantityText.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill at least one row')),
        );
        return [];
      }

      if (name.isEmpty && quantityText.isEmpty) {
        continue;
      }

      if (name.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Row ${i + 1}: Product name is empty')),
        );
        productsFocusNodes[i].requestFocus();
        return [];
      }

      final quantity = int.tryParse(quantityText);
      if (quantity == null || quantity <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Row ${i + 1}: Quantity must be a positive number')),
        );
        quantityFocusNodes[i].requestFocus();
        return [];
      }

      result.add((name, quantity, images[i], notes[i]));
    }

    return result;
  }

  void clearAllFields() {
    for (int i = 0; i < productsControllers.length; i++) {
      productsControllers[i].clear();
      quantityControllers[i].clear();
      notes[i] = null;
      images[i] = null;
    }
    setState(() {});
  }
}

class OrdersTableController {
  _OrdersTableState? _state;

  void _attach(_OrdersTableState state) {
    _state = state;
  }

  List<(String name, int quantity, XFile? image, String? note)> getFilledRows() {
    return _state?.getFilledRows(_state!.context) ?? [];
  }

  void clearAll() {
    _state?.clearAllFields();
  }
}
