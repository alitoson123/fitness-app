import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';
import '../widgets/trainee_profile_body.dart';

class TraineeProfilePage extends StatelessWidget {
  const TraineeProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).traineeProfileTitle),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: TraineeProfileBody(),
      ),
    );
  }
}
