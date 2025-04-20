import 'package:flutter/material.dart';
import 'package:flutter_developer_test/theme/app_colors.dart';

class ProductTextField extends StatelessWidget {
  const ProductTextField({
    super.key,
    this.controller,
    this.focusNode,
    required this.suggestions,
    this.onTap,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final List<String> suggestions;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) return const Iterable<String>.empty();
        return suggestions.where(
          (item) => item.toLowerCase().contains(textEditingValue.text.toLowerCase()),
        );
      },
      fieldViewBuilder: (context, textEditingController, node, onFieldSubmitted) {
        // Initialize the internal controller with the external controller's text
        if (controller != null && textEditingController.text.isEmpty) {
          textEditingController.text = controller!.text;
        }

        // Update the external controller when the internal controller changes
        textEditingController.addListener(() {
          if (controller != null && controller!.text != textEditingController.text) {
            controller!.text = textEditingController.text;
          }
        });

        return TextField(
          onTap: onTap,
          controller: textEditingController,
          cursorColor: AppColors.bodyText,
          focusNode: node, // Use the provided node, not the external focusNode
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 8, right: 8, top: 8),
          ),
        );
      },
      onSelected: (String selection) {
        // Update both the internal field and the external controller
        if (controller != null) {
          controller!.text = selection;
        }
      },
    );
  }
}
