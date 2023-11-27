import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zen_tasker/app/model/category.dart';
import 'package:zen_tasker/app/model/task.dart';
import 'package:zen_tasker/app/model/task_model.dart';
import 'package:zen_tasker/app/view/components/title.dart';
import 'package:zen_tasker/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

final List<String> predefinedCategories = Category.getPredefinedCategories()
    .map((category) => category.name)
    .toList();
String? selectedCategory = predefinedCategories.first;

class TaskDetailsModal extends StatefulWidget {
  final Task task;

  const TaskDetailsModal({Key? key, required this.task}) : super(key: key);

  @override
  _TaskDetailsModalState createState() => _TaskDetailsModalState();
}

class _TaskDetailsModalState extends State<TaskDetailsModal> {
  @override
  void initState() {
    super.initState();
    //selectedCategory = predefinedCategories.first;
    selectedCategory = widget.task.category ?? predefinedCategories.first;
  }

  @override
  Widget build(BuildContext context) {
    final _detailsController = TextEditingController(text: widget.task.detail);
    DateTime? _dueDate = widget.task.dueDate;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 22),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(21)),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 30),
              const Align(
                alignment: AlignmentDirectional.centerStart,
                child: TitleH1("Detalles de la tarea"),
              ),
              const SizedBox(height: 26),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: DropdownButton<String>(
                  value: selectedCategory,
                  onChanged: (String? value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                  items: predefinedCategories
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 26),
              TextFormField(
                controller: _detailsController,
                cursorColor: customPrimaryTextColor,
                showCursor: true,
                style: DefaultTextStyle.of(context).style,
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
              DateTimeField(
                format: DateFormat("dd/MM/yyyy HH:mm"),
                decoration: InputDecoration(
                  labelText: _dueDate != null
                      ? 'Fecha seleccionada: ${DateFormat('dd/MM/yyyy HH:mm').format(_dueDate!)}'
                      : 'Vencimiento',
                  labelStyle: DefaultTextStyle.of(context).style,
                ),
                onChanged: (date) {
                  _dueDate = date;
                  widget.task.dueDate = _dueDate;
                  Provider.of<TaskModel>(context, listen: false)
                      .updateTask(widget.task);
                },
                onShowPicker: (context, currentValue) async {
                  final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                          currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.combine(date, time);
                  } else {
                    return currentValue;
                  }
                },
              ),
              const SizedBox(height: 26),
              ElevatedButton(
                onPressed: () {
                  Task updatedTask = widget.task.copyWith(
                    detail: _detailsController.text,
                    dueDate: _dueDate,
                    category: selectedCategory,
                  );
                  Provider.of<TaskModel>(context, listen: false)
                      .updateTask(updatedTask);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: customPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Guardar',
                  style: TextStyle(color: customSecundaryTextColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
