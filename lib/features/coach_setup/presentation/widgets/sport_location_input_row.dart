import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../generated/l10n.dart';

class SportLocationInputRow extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAdd;
  final Color primary;

  const SportLocationInputRow({
    super.key,
    required this.controller,
    required this.onAdd,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            controller: controller,
            hint: s.enterLocationHint,
            onFieldSubmitted: (_) => onAdd(),
          ),
        ),
        SizedBox(width: 8.w),
        IconButton.filled(
          onPressed: onAdd,
          icon: const Icon(Icons.add_location_alt_rounded),
          style: IconButton.styleFrom(backgroundColor: primary),
        ),
      ],
    );
  }
}
