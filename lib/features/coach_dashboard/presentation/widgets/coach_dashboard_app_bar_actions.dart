import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../generated/l10n.dart';
import '../../../auth/core/presentation/view_model/auth_session_cubit/auth_session_cubit.dart';
import '../../../auth/core/widgets/delete_account_dialog.dart';

class CoachDashboardAppBarActions extends StatelessWidget {
  final ValueChanged<int> onNavigateToTab;

  const CoachDashboardAppBarActions({
    super.key,
    required this.onNavigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final authCubit = context.read<AuthSessionCubit>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.schedule_outlined),
          tooltip: s.manageWorkingHours,
          onPressed: () => onNavigateToTab(2),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert_rounded),
          onSelected: (value) {
            if (value == 'sign_out') {
              authCubit.signOut();
            } else if (value == 'delete_account') {
              DeleteAccountDialog.show(
                context,
                onConfirm: () => authCubit.deleteAccount(),
              );
            }
          },
          itemBuilder: (ctx) => [
           
            
            PopupMenuItem(
              value: 'sign_out',
              child: Row(
                children: [
                  const Icon(Icons.logout_rounded, size: 18),
                  const SizedBox(width: 8),
                  Text(s.signOut),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete_account',
              child: Row(
                children: [
                  const Icon(
                    Icons.delete_outline_rounded,
                    size: 18,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    s.deleteAccount,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
