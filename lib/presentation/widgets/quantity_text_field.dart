import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_developer_test/theme/app_colors.dart';

class QuantityTextField extends StatelessWidget {
  const QuantityTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.onTap,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: onTap,
      controller: controller,
      focusNode: focusNode,
      maxLines: 1,
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(left: 8, right: 8, top: 8),
      ),
      cursorColor: AppColors.bodyText,
      textAlign: TextAlign.right,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: Theme.of(context).textTheme.labelSmall,
    );
  }
}
