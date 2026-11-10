import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helpers/message.dart';
import '../../../../core/locator_service/service_locator.dart';
import '../../../../core/services/auth_service/auth_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../view_model/notifications_cubit/notifications_cubit.dart';
import '../view_model/notifications_cubit/notifications_state.dart';
import '../widgets/notifications_filter_bar.dart';
import '../widgets/notifications_list_body.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUid = getIt<AuthService>().currentUser?.uid ?? '';

    // If NotificationsCubit is already provided above in the tree, reuse it;
    // otherwise, provide a fresh instance initialized for currentUid.
    Widget content = const _NotificationsScaffold();
    try {
      context.read<NotificationsCubit>();
    } catch (_) {
      content = BlocProvider(
        create: (_) =>
            getIt<NotificationsCubit>()..listenToNotifications(currentUid),
        child: content,
      );
    }

    return content;
  }
}

class _NotificationsScaffold extends StatelessWidget {
  const _NotificationsScaffold();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentUid = getIt<AuthService>().currentUser?.uid ?? '';
    final cubit = context.read<NotificationsCubit>();

    return BlocConsumer<NotificationsCubit, NotificationsState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          Message.showError(context, state.errorMessage!);
          cubit.clearMessages();
        } else if (state.successMessage == 'all_read') {
          Message.showSuccess(context, s.allNotificationsMarkedRead);
          cubit.clearMessages();
        } else if (state.successMessage == 'deleted') {
          Message.showSuccess(context, s.notificationDeleted);
          cubit.clearMessages();
        }
      },
      builder: (context, state) {
        final hasUnread = state.unreadCount > 0;

        return Scaffold(
          backgroundColor: isDark
              ? AppColors.darkBackground
              : AppColors.backgroundSecondary,
          appBar: AppBar(
            title: Text(s.notificationCenter),
            centerTitle: true,
            actions: [
              if (hasUnread)
                IconButton(
                  tooltip: s.markAllAsRead,
                  icon: const Icon(Icons.done_all_rounded),
                  onPressed: () => cubit.markAllAsRead(currentUid),
                ),
            ],
          ),
          body: Column(
            children: [
              NotificationsFilterBar(
                activeFilter: state.filter,
                allCount: state.notifications.length,
                bookingsCount: state.bookingCount,
                adminCount: state.adminCount,
                onFilterChanged: cubit.setFilter,
              ),
              Expanded(
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : NotificationsListBody(
                        notifications: state.filteredNotifications,
                        isFiltered: state.filter != NotificationFilter.all,
                        onRefresh: () async {
                          cubit.listenToNotifications(currentUid);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
