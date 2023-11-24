import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zen_tasker/app/model/task_model.dart';
import 'package:zen_tasker/app/view/components/title.dart';
import 'package:zen_tasker/app/view/task_list/new_task_modal.dart';
import 'package:zen_tasker/app/view/task_list/task_item.dart';
import 'package:zen_tasker/utils/colors.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await Provider.of<TaskModel>(context, listen: false).loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de tareas',
          style: TextStyle(color: customSecundaryTextColor),
        ),
        backgroundColor: customPrimaryColor,
      ),
      body: _buildBody(context),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<TaskModel>(
      builder: (context, taskModel, child) {
        if (taskModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (taskModel.error != null) {
          return _buildError(taskModel.error!);
        } else if (taskModel.tasks.isEmpty) {
          return _buildEmptyTaskListMessage();
        } else {
          return _buildTaskList(taskModel);
        }
      },
    );
  }

  Widget _buildEmptyTaskListMessage() {
    return const Center(
      child: TextH2(
        'No tienes tareas registradas',
      ),
    );
  }

  Widget _buildError(Object error) {
    String errorMessage;
    if (error is Exception) {
      errorMessage = 'Ha ocurrido un error: ${error.toString()}';
    } else {
      errorMessage = 'Ha ocurrido un error desconocido';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Text(
          errorMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildTaskList(TaskModel taskModel) {
    return ReorderableListView(
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
    );
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showNewTaskModal(context),
      child: const Icon(Icons.add, color: customSecundaryTextColor),
      backgroundColor: customPrimaryColor,
    );
  }

  void _showNewTaskModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: NewTaskModal(),
        ),
      ),
    );
  }
}
