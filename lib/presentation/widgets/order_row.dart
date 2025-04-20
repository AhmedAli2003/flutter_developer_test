import 'package:flutter/material.dart';
import 'package:flutter_developer_test/presentation/widgets/quantity_text_field.dart';
import 'package:flutter_developer_test/presentation/widgets/product_text_field.dart';
import 'package:flutter_developer_test/theme/app_colors.dart';

class OrderRow extends StatelessWidget {
  const OrderRow({
    super.key,
    this.productController,
    this.productFocusNode,
    this.quantityController,
    this.quantityFocusNode,
    this.onTap,
    this.hasImage = false,
    this.hasNote = false,
    this.suggestions = const [],
  });

  final TextEditingController? productController;
  final FocusNode? productFocusNode;
  final TextEditingController? quantityController;
  final FocusNode? quantityFocusNode;
  final void Function()? onTap;
  final bool hasImage;
  final bool hasNote;
  final List<String> suggestions;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.primary),
        ),
      ),
      child: Row(
        children: [
          // Number input (left cell)
          SizedBox(
            width: 50,
            child: QuantityTextField(
              controller: quantityController,
              focusNode: quantityFocusNode,
              onTap: onTap,
            ),
          ),
          // Vertical blue line
          Container(
            width: 1,
            height: 50,
            color: AppColors.primary,
          ),
          // Description input (right cell)
          Expanded(
            child: ProductTextField(
              controller: productController,
              focusNode: productFocusNode,
              onTap: onTap,
              suggestions: suggestions,
            ),
          ),
          if (hasNote) const Icon(Icons.info_outline),
          if (hasImage) const Icon(Icons.image),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
