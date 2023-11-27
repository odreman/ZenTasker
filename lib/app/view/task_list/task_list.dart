import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zen_tasker/app/model/category.dart';
import 'package:zen_tasker/app/model/task.dart';
import 'package:zen_tasker/app/model/task_model.dart';
import 'package:zen_tasker/app/view/task_list/task_item.dart';
import 'package:zen_tasker/utils/colors.dart';

//Deprecado

final List<String> predefinedCategories = Category.getPredefinedCategories()
    .map((category) => category.name)
    .toList();

class TaskList extends StatefulWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  String selectedCategory = predefinedCategories.first;

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskModel>(
      builder: (context, taskModel, child) {
        List<Task> filteredTasks = taskModel.tasks.where((task) {
          return task.category == selectedCategory;
        }).toList();

        return Container(
          color: Theme.of(context).colorScheme.background,
          width: double.infinity,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ToggleButtons(
                  children: predefinedCategories
                      .map((category) => Text(category))
                      .toList(),
                  isSelected: predefinedCategories
                      .map((category) => category == selectedCategory)
                      .toList(),
                  color: customAlternateColor,
                  selectedColor: customTertiaryColor,
                  borderRadius: BorderRadius.circular(10),
                  onPressed: (int index) {
                    setState(() {
                      selectedCategory = predefinedCategories[index];
                    });
                  },
                ),
              ),
              const SizedBox(height: 30),
              //Columna 3 Lista de tareas
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ReorderableListView(
                    onReorder: (oldIndex, newIndex) {
                      taskModel.reorderTasks(oldIndex, newIndex);
                    },
                    children: filteredTasks.map((task) {
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
        );
      },
    );
  }
}
