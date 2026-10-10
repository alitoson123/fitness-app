import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';
import 'coach_filter_icon_button.dart';

class CoachSearchBar extends StatefulWidget {
  final String initialQuery;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onFilterTap;
  final int activeFiltersCount;

  const CoachSearchBar({
    super.key,
    required this.initialQuery,
    required this.onQueryChanged,
    required this.onFilterTap,
    this.activeFiltersCount = 0,
  });

  @override
  State<CoachSearchBar> createState() => _CoachSearchBarState();
}

class _CoachSearchBarState extends State<CoachSearchBar> {
  late final TextEditingController _controller;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void didUpdateWidget(covariant CoachSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialQuery != oldWidget.initialQuery &&
        widget.initialQuery != _controller.text) {
      _controller.text = widget.initialQuery;
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String val) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      widget.onQueryChanged(val);
    });
    setState(() {});
  }

  void _clear() {
    _controller.clear();
    _debounceTimer?.cancel();
    widget.onQueryChanged('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final bg = isDark ? AppColors.darkSurfaceVariant : AppColors.surface;
    final border = isDark ? AppColors.darkBorder : AppColors.border;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 46.h,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: AppRadius.mdAll,
                border: Border.all(color: border),
              ),
              child: TextField(
                controller: _controller,
                onChanged: _onChanged,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: S.of(context).searchCoaches,
                  hintStyle: TextStyle(
                    fontSize: 13.sp,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textTertiary,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 20.r,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear_rounded, size: 18.r),
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                          onPressed: _clear,
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          CoachFilterIconButton(
            onTap: widget.onFilterTap,
            activeCount: widget.activeFiltersCount,
            primaryColor: primary,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}
