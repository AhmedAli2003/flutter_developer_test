import 'package:flutter/material.dart';
import 'package:flutter_developer_test/controllers/suggestions_provider.dart';
import 'package:flutter_developer_test/presentation/widgets/modal_sheet_widget.dart';
import 'package:flutter_developer_test/presentation/widgets/order_row.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

/// A dynamic and interactive table for entering orders.
/// Displays multiple rows of products and their quantities.
/// Also supports notes, images, and product suggestions.
class OrdersTable extends ConsumerStatefulWidget {
  const OrdersTable({super.key, required this.controller});

  /// External controller to access methods like getFilledRows and clearAll
  final OrdersTableController? controller;

  @override
  ConsumerState<OrdersTable> createState() => _OrdersTableState();
}

class _OrdersTableState extends ConsumerState<OrdersTable> {
  int rowCount = 20;

  /// Controllers and focus nodes for product names and quantities
  late List<TextEditingController> productsControllers;
  late List<FocusNode> productsFocusNodes;
  late List<TextEditingController> quantityControllers;
  late List<FocusNode> quantityFocusNodes;

  /// Additional data per row
  late List<String?> notes;
  late List<XFile?> images;

  @override
  void initState() {
    super.initState();

    // Initialize lists
    productsControllers = [];
    productsFocusNodes = [];
    quantityControllers = [];
    quantityFocusNodes = [];
    notes = [];
    images = [];

    // Start with a fixed number of rows
    _initRows(rowCount);

    // Attach to external controller
    widget.controller?._attach(this);
  }

  /// Initializes a given number of rows and attaches listeners
  void _initRows(int count) {
    for (int i = productsControllers.length; i < count; i++) {
      final pController = TextEditingController();
      final qController = TextEditingController();

      // Optional: add listeners to expand if needed
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

  /// Checks if the current row is the last and filled.
  /// If so, adds more rows.
  void _checkToAddMoreRows(int index) {
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
    // Fetch product suggestions from provider
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

  /// Auto-focuses the first incomplete row above the current one
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

  /// Opens the modal to add a note/image to a product
  void handleLongPressAndDoubleTap(int index) {
    if (productsControllers[index].text.trim().isNotEmpty) {
      openNoteModal(index);
    }
  }

  /// Shows the bottom modal for notes/images
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

  /// Extracts and validates all filled rows before saving
  /// Shows SnackBars if any validation fails
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

  /// Clears all fields and resets notes/images
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

/// A controller to access internal methods of OrdersTable from outside.
/// Used to get validated rows or clear all inputs.
class OrdersTableController {
  _OrdersTableState? _state;

  void _attach(_OrdersTableState state) {
    _state = state;
  }

  /// Returns validated filled rows from the table
  List<(String name, int quantity, XFile? image, String? note)> getFilledRows() {
    return _state?.getFilledRows(_state!.context) ?? [];
  }

  /// Clears all table fields and notes/images
  void clearAll() {
    _state?.clearAllFields();
  }
}
