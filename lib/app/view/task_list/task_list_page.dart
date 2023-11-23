import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zen_tasker/app/model/task_model.dart';
import 'package:zen_tasker/app/view/task_list/new_task_modal.dart';
import 'package:zen_tasker/app/view/task_list/task_list.dart';
import 'package:zen_tasker/constants/Colors.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de tareas'),
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
        } else {
          return _buildTaskList();
        }
      },
    );
  }

  Widget _buildError(Object error) {
    String errorMessage;
    if (error is Exception) {
      // Aquí puedes manejar diferentes tipos de excepciones y proporcionar mensajes de error más amigables
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
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    return TaskList();
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showNewTaskModal(context),
      child: const Icon(Icons.add),
      backgroundColor: customPrimaryColor,
      shape: const CircleBorder(
        side: BorderSide(color: Colors.white, width: 4),
      ),
    );
  }

  void _showNewTaskModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => NewTaskModal(),
    );
  }
}
