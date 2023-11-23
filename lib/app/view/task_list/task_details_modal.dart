import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zen_tasker/app/model/task.dart';
import 'package:zen_tasker/app/model/task_model.dart';
import 'package:zen_tasker/constants/colors.dart';

class TaskDetailsModal extends StatelessWidget {
  final Task task;

  TaskDetailsModal({required this.task});

  void showTaskDetailsModal(BuildContext context) {
    final _detailsController = TextEditingController(text: task.detail);
    DateTime? _dueDate = task.dueDate;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 22),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(21)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 30),
                  const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('Detalles de la tarea',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 26),
                  TextFormField(
                    controller: _detailsController,
                    decoration: InputDecoration(
                      hintText: 'Añade detalles a la tarea',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    minLines: 3,
                    maxLines: null,
                  ),
                  const SizedBox(height: 26),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          customTertiaryColor, // Usa tu color personalizado aquí
                    ),
                    onPressed: () {
                      DatePicker.showDateTimePicker(
                        context,
                        showTitleActions: true,
                        onChanged: (date) {
                          setState(() {
                            _dueDate = date;
                          });
                        },
                        onConfirm: (date) {
                          setState(() {
                            _dueDate = date;
                          });
                        },
                        currentTime: DateTime.now(),
                        locale: LocaleType.es,
                      );
                    },
                    child: Text('Vencimiento'),
                  ),
                  SizedBox(height: 20),
                  if (_dueDate != null)
                    Text(
                        'Fecha seleccionada: ${DateFormat('dd/MM/yyyy HH:mm').format(_dueDate!)}'),
                  const SizedBox(height: 26),
                  ElevatedButton(
                    onPressed: () {
                      task.detail = _detailsController.text;
                      task.dueDate = _dueDate;
                      var taskModel =
                          Provider.of<TaskModel>(context, listen: false);
                      taskModel.updateTask(task);
                      Navigator.pop(context);
                    },
                    child: const Text('Guardar'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => showTaskDetailsModal(context),
      child: Text('Mostrar detalles de la tarea'),
    );
  }
}
