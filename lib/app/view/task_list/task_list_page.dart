import 'package:chip_list/chip_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:zen_tasker/app/model/category.dart';
import 'package:zen_tasker/app/model/task.dart';
import 'package:zen_tasker/app/model/task_model.dart';
import 'package:zen_tasker/app/view/components/title.dart';
import 'package:zen_tasker/app/view/task_list/input_field.dart';
import 'package:zen_tasker/app/view/task_list/new_task_modal.dart';
import 'package:zen_tasker/app/view/task_list/task_item.dart';
import 'package:zen_tasker/utils/constants.dart';

final List<String> predefinedCategories = Category.getPredefinedCategories()
    .map((category) => category.name)
    .toList();

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  String selectedCategory = "Todos";
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
      body: Stack(
        children: [
          _buildBody(context),
          Positioned(
            bottom: 80.0,
            right: 20.0,
            child: FloatingActionButton(
              onPressed: () => _showNewTaskModal(context),
              child: const Icon(Icons.add, color: customSecundaryTextColor),
              backgroundColor: customPrimaryColor,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: customPrimaryBackgroundColor,
              padding: const EdgeInsets.all(8.0),
              child: InputField(
                controller: _controller,
                onSubmitted: (text) {
                  var uuid = const Uuid();
                  final task = Task(uuid.v4(), text,
                      category: selectedCategory == "Todos"
                          ? "Ninguna categoría"
                          : selectedCategory);
                  Provider.of<TaskModel>(context, listen: false).addTask(task);
                },
              ),
            ),
          ),
        ],
      ),
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
    List<Task> filteredTasks = taskModel.tasks.where((task) {
      return selectedCategory == "Todos" || task.category == selectedCategory;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 50.0,
            child: ChipList(
              listOfChipNames: ["Todos"] +
                  predefinedCategories
                      .where((category) => category != "Todos")
                      .toList(),
              activeBgColorList: const [customTertiaryColor],
              inactiveBgColorList: const [customSecundaryBackgroundColor],
              activeTextColorList: const [Colors.white],
              inactiveTextColorList: const [Colors.black],
              listOfChipIndicesCurrentlySeclected: (selectedCategory == "Todos")
                  ? [0]
                  : [1 + predefinedCategories.indexOf(selectedCategory)],
              extraOnToggle: (index) {
                setState(() {
                  selectedCategory =
                      (index == 0) ? "Todos" : predefinedCategories[index - 1];
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 15),
        Expanded(
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
      ],
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
