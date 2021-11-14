import 'package:flutter/material.dart';
import 'package:habit_tracker_flutter/constants/text_styles.dart';
import 'package:habit_tracker_flutter/models/task_preset.dart';
import 'package:habit_tracker_flutter/ui/task/animated_task.dart';
import 'package:habit_tracker_flutter/ui/theming/app_theme.dart';

class TaskWithName extends StatelessWidget {
  const TaskWithName({Key? key, required this.preset}) : super(key: key);
  final TaskPreset preset;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedTask(iconName: preset.iconName),
        SizedBox(
          height: 8,
        ),
        Text(
          preset.name.toUpperCase(),
          style: TextStyles.taskName.copyWith(
            color: AppTheme.of(context).accent,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
