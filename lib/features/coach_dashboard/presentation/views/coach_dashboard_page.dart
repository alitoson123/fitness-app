import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';
import '../widgets/coach_dashboard_app_bar_actions.dart';
import '../widgets/coach_dashboard_body.dart';

class CoachDashboardPage extends StatelessWidget {
  final ValueChanged<int> onNavigateToTab;

  const CoachDashboardPage({
    super.key,
    required this.onNavigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).coachDashboard),
        centerTitle: true,
        actions: [
          CoachDashboardAppBarActions(
            onNavigateToTab: onNavigateToTab,
          ),
        ],
      ),
      body: CoachDashboardBody(
        onNavigateToTab: onNavigateToTab,
      ),
    );
  }
}
