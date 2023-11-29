import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zen_tasker/app/model/task.dart';
import 'package:zen_tasker/app/model/task_model.dart';
import 'package:zen_tasker/app/view/components/title.dart';
import 'package:zen_tasker/utils/constants.dart';

class NewTaskModal extends StatelessWidget {
  NewTaskModal({Key? key}) : super(key: key);

  final _controller = TextEditingController();

  void _saveTask(BuildContext context) {
    if (_controller.text.isNotEmpty) {
      var taskModel = Provider.of<TaskModel>(context, listen: false);
      var newTask = Task(
        generateId(), // Usamos el tiempo actual como ID único
        _controller.text,
        isDone: false, // La tarea nueva no está hecha
      );
      taskModel.addTask(newTask);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 22),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(21)),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 30),
            //Columna 1 Titulo
            const Align(
              alignment: AlignmentDirectional.centerStart,
              child: TitleH1('Nueva Tarea'),
            ),
            //Columna 2 Input
            const SizedBox(height: 26),
            TextField(
              controller: _controller,
              cursorColor: customPrimaryTextColor,
              showCursor: true,
              style: DefaultTextStyle.of(context).style,
              decoration: InputDecoration(
                hintText: 'Descripción de la tarea',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onSubmitted: (_) => _saveTask(context),
            ),
            //Columna 3 Boton guardar
            const SizedBox(height: 26),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  var taskModel =
                      Provider.of<TaskModel>(context, listen: false);
                  var newTask = Task(
                    generateId(), // Usamos el tiempo actual como ID único
                    _controller.text,
                    isDone: false, // La tarea nueva no está hecha
                  );
                  taskModel.addTask(newTask);
                  Navigator.pop(context);
                }
              },
              child: const Text('Guardar',
                  style: TextStyle(color: customSecundaryTextColor)),
            ),
          ],
        ),
      ),
    );
  }
}

int generateId() {
  return (DateTime.now().millisecondsSinceEpoch / 1000).round();
}
