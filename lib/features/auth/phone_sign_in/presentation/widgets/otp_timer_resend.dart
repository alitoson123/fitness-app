import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fitness_app/generated/l10n.dart';

class OtpTimerResend extends StatefulWidget {
  final VoidCallback onResend;

  const OtpTimerResend({
    super.key,
    required this.onResend,
  });

  @override
  State<OtpTimerResend> createState() => _OtpTimerResendState();
}

class _OtpTimerResendState extends State<OtpTimerResend> {
  static const int _initialCountdown = 60;
  int _secondsRemaining = _initialCountdown;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsRemaining = _initialCountdown);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _handleResend() {
    if (_secondsRemaining == 0) {
      widget.onResend();
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final canResend = _secondsRemaining == 0;

    return Center(
      child: canResend
          ? TextButton.icon(
              onPressed: _handleResend,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(
                s.resendCode,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          : Text(
              s.resendCodeIn(_secondsRemaining.toString()),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
    );
  }
}
