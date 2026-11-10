import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigator/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../view_model/notifications_cubit/notifications_cubit.dart';
import '../view_model/notifications_cubit/notifications_state.dart';

class NotificationIconButton extends StatelessWidget {
  final Color? iconColor;

  const NotificationIconButton({super.key, this.iconColor});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocBuilder<NotificationsCubit, NotificationsState>(
      buildWhen: (prev, curr) => prev.unreadCount != curr.unreadCount,
      builder: (context, state) {
        final count = state.unreadCount;
        final hasUnread = count > 0;

        return IconButton(
          tooltip: s.notificationsTooltip,
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                hasUnread
                    ? Icons.notifications_rounded
                    : Icons.notifications_outlined,
                color: iconColor,
                size: 24.sp,
              ),
              if (hasUnread)
                Positioned(
                  top: -2.h,
                  right: -4.w,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) =>
                        ScaleTransition(scale: animation, child: child),
                    child: Container(
                      key: ValueKey<int>(count),
                      padding: EdgeInsets.symmetric(
                        horizontal: count > 9 ? 4.w : 2.w,
                        vertical: 1.h,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16.w,
                        minHeight: 16.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 1.5.w,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          count > 99 ? '99+' : '$count',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          onPressed: () {
            context.push(AppRoutes.notifications);
          },
        );
      },
    );
  }
}
