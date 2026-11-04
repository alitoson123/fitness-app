import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../generated/l10n.dart';
import '../constant/app_sports.dart';
import 'other_sport_input_field.dart';
import 'sport_chip_item.dart';

class SportsSelectorWidget extends StatefulWidget {
  final List<String> selectedSports;
  final ValueChanged<String> onSportToggled;
  final ValueChanged<String> onCustomSportAdded;
  final ValueChanged<String> onCustomSportRemoved;

  const SportsSelectorWidget({
    super.key,
    required this.selectedSports,
    required this.onSportToggled,
    required this.onCustomSportAdded,
    required this.onCustomSportRemoved,
  });

  @override
  State<SportsSelectorWidget> createState() => _SportsSelectorWidgetState();
}

class _SportsSelectorWidgetState extends State<SportsSelectorWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _isOtherOpen = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleAddSport() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onCustomSportAdded(text);
      _controller.clear();
    }
  }

  void _toggleOther() {
    setState(() {
      _isOtherOpen = !_isOtherOpen;
    });
  }

  bool _isSportSelected(String key) {
    final target = AppSports.normalize(key);
    return widget.selectedSports.any(
      (s) => AppSports.normalize(s) == target,
    );
  }

  List<String> get _customSports {
    return widget.selectedSports
        .where((s) =>
            !AppSports.isPredefined(s) &&
            AppSports.normalize(s) != AppSports.otherKey)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: 8.w,
          runSpacing: 10.h,
          children: [
            ...AppSports.popularSports.map((item) {
              final isSelected = _isSportSelected(item.key);
              return SportChipItem(
                emoji: item.emoji,
                label: AppSports.getLocalizedSportName(context, item.key),
                isSelected: isSelected,
                onTap: () => widget.onSportToggled(item.key),
              );
            }),
            ..._customSports.map((customSport) {
              return SportChipItem(
                emoji: AppSports.customSportEmoji,
                label: customSport,
                isSelected: true,
                onTap: () => widget.onSportToggled(customSport),
                onRemove: () => widget.onCustomSportRemoved(customSport),
              );
            }),
            SportChipItem(
              emoji: AppSports.otherEmoji,
              label: s.sportOther,
              isSelected: _isOtherOpen || _customSports.isNotEmpty,
              onTap: _toggleOther,
            ),
          ],
        ),
        if (_isOtherOpen) ...[
          SizedBox(height: 12.h),
          OtherSportInputField(
            controller: _controller,
            onAdd: _handleAddSport,
          ),
        ],
      ],
    );
  }
}
