import 'package:flutter/material.dart';
import 'package:flutter_developer_test/theme/app_colors.dart';

class OrderDetailRow extends StatelessWidget {
  const OrderDetailRow({
    super.key,
    required this.label,
    required this.value,
    this.valueTextStyle,
    this.optional = false,
    this.location = false,
  });

  final String label;
  final String value;
  final TextStyle? valueTextStyle;
  final bool optional;
  final bool location;

  @override
  Widget build(BuildContext context) {
    final labelText = Text(
      '$label  ',
      style: Theme.of(context).textTheme.titleMedium,
    );

    final valueText = Text(
      value,
      maxLines: 2,
      style: valueTextStyle ??
          Theme.of(context).textTheme.titleMedium!.copyWith(
                color: AppColors.primary,
              ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                labelText,
                if (optional)
                  Text(
                    'optional',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 10),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (location)
                  Text(
                    'Deliver to:',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 10),
                  ),
                valueText,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
