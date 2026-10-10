import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../generated/l10n.dart';

class FilterBottomSheetHeader extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onClose;
  final Color primaryColor;
  final Color textPrimaryColor;

  const FilterBottomSheetHeader({
    super.key,
    required this.onReset,
    required this.onClose,
    required this.primaryColor,
    required this.textPrimaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 12.w, 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            S.of(context).filters,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: textPrimaryColor,
            ),
          ),
          Row(
            children: [
              TextButton(
                onPressed: onReset,
                child: Text(
                  S.of(context).reset,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: onClose,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
