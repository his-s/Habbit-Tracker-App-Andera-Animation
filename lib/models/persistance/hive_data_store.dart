import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker_flutter/models/task.dart';
import 'package:habit_tracker_flutter/models/task_state.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDataStore {
  static const tasksBoxName = 'tasks';
  static const tasksStateBoxName = 'tasksState';
  static String taskStateKey(String key) => 'tasksState/$key';
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter<Task>(TaskAdapter());
    Hive.registerAdapter<TaskState>(TaskStateAdapter());
    await Hive.openBox<Task>(tasksBoxName);
    await Hive.openBox<TaskState>(tasksBoxName);
  }

  Future<void> createDemoTasks({
    required List<Task> tasks,
    required bool force,
  }) async {
    final box = Hive.box<Task>(tasksBoxName);
    if (box.isEmpty || force) {
      await box.clear();
      await box.addAll(tasks);
    }
  }

  ValueListenable<Box<Task>> tasksListenable() {
    return Hive.box<Task>(tasksBoxName).listenable();
  }

  Future<void> setTaskState({
    required Task task,
    required bool isCompleted,
  }) async {
    final box = Hive.box<TaskState>(tasksBoxName);
    final taskState = TaskState(id: task.id, isCompleted: isCompleted);
    await box.put(taskStateKey(task.id), taskState);
  }

  ValueListenable<Box<TaskState>> tasksStateListenable({required Task task}) {
    final box = Hive.box<TaskState>(tasksStateBoxName);
    final key = taskStateKey(task.id);

    return box.listenable(keys: <String>[key]);
  }
}

final dataStoreProvider = Provider<HiveDataStore>(
  (ref) {
    throw UnimplementedError();
  },
);
