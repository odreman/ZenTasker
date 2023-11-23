import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zen_tasker/app/model/task_model.dart';
import 'package:zen_tasker/app/view/task_list/task_item.dart';

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskModel>(
      builder: (context, taskModel, child) => Container(
        color: Theme.of(context).colorScheme.background,
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 30),
            //Columna 3 Lista de tareas
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.separated(
                  itemBuilder: (_, index) => TaskItem(
                    taskModel.tasks[index],
                    onTap: () => taskModel.toggleDone(taskModel.tasks[index]),
                    onDelete: () =>
                        taskModel.deleteTask(taskModel.tasks[index]),
                    onTaskUpdated: taskModel.updateTask,
                  ),
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemCount: taskModel.tasks.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
