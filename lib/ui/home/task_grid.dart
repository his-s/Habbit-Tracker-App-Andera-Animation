import 'package:flutter/material.dart';
import 'package:habit_tracker_flutter/models/task_preset.dart';
import 'package:habit_tracker_flutter/ui/task/task_with_name.dart';

class TaskGrid extends StatelessWidget {
  const TaskGrid({Key? key, required this.presets}) : super(key: key);
  final List<TaskPreset> presets;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (BuildContext context, int index) {
        return TaskWithName(task: presets[index]);
      },
      itemCount: presets.length,
    );
  }
}
