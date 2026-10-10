import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';

class ShimmerCoachListLoading extends StatefulWidget {
  const ShimmerCoachListLoading({super.key});

  @override
  State<ShimmerCoachListLoading> createState() =>
      _ShimmerCoachListLoadingState();
}

class _ShimmerCoachListLoadingState extends State<ShimmerCoachListLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.35, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final shimmerBase =
        isDark ? AppColors.darkSurfaceVariant : AppColors.border;

    return AnimatedBuilder(
      animation: _opacity,
      builder: (context, child) {
        return ListView.builder(
          itemCount: 4,
          padding: EdgeInsets.symmetric(vertical: 8.h),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: AppRadius.lgAll,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
              ),
              child: Opacity(
                opacity: _opacity.value,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 64.r,
                      height: 64.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: shimmerBase,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 140.w,
                            height: 16.h,
                            decoration: BoxDecoration(
                              color: shimmerBase,
                              borderRadius: AppRadius.smAll,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            width: 100.w,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: shimmerBase,
                              borderRadius: AppRadius.smAll,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Container(
                                width: 50.w,
                                height: 20.h,
                                decoration: BoxDecoration(
                                  color: shimmerBase,
                                  borderRadius: AppRadius.smAll,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Container(
                                width: 50.w,
                                height: 20.h,
                                decoration: BoxDecoration(
                                  color: shimmerBase,
                                  borderRadius: AppRadius.smAll,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Container(
                            width: 80.w,
                            height: 14.h,
                            decoration: BoxDecoration(
                              color: shimmerBase,
                              borderRadius: AppRadius.smAll,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
