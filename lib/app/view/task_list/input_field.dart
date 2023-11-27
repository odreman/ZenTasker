import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;

  const InputField(
      {super.key, required this.controller, required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Nueva tarea',
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () {
            if (controller.text.isNotEmpty) {
              onSubmitted(controller.text);
              controller.clear();
              FocusScope.of(context).unfocus();
            }
          },
        ),
      ],
    );
  }
}
