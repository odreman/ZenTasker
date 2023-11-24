import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zen_tasker/app/model/task_model.dart';
import 'package:zen_tasker/app/view/task_list/task_item.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskModel>(
      builder: (context, taskModel, child) => Container(
        color: Theme.of(context).colorScheme.background,
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 30),
            //Columna 3 Lista de tareas
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ReorderableListView(
                  onReorder: (oldIndex, newIndex) {
                    taskModel.reorderTasks(oldIndex, newIndex);
                  },
                  children: taskModel.tasks.map((task) {
                    return TaskItem(
                      key: Key(task.id.toString()),
                      task,
                      onTap: () => taskModel.toggleDone(task),
                      onDelete: () => taskModel.deleteTask(task),
                      onTaskUpdated: taskModel.updateTask,
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
