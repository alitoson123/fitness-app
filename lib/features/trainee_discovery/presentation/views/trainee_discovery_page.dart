import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';
import '../../../notifications/presentation/widgets/notification_icon_button.dart';
import '../widgets/trainee_discovery_body.dart';

class TraineeDiscoveryPage extends StatelessWidget {
  const TraineeDiscoveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).traineeDiscovery),
        centerTitle: true,
        actions: const [
          NotificationIconButton(),
        ],
      ),
      body: const SafeArea(
        child: TraineeDiscoveryBody(),
      ),
    );
  }
}
