import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';
import '../widgets/trainee_discovery_body.dart';

class TraineeDiscoveryPage extends StatelessWidget {
  const TraineeDiscoveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).traineeDiscovery),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: TraineeDiscoveryBody(),
      ),
    );
  }
}
