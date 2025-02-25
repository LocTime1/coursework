import 'package:flutter/material.dart';

class AddTaskName extends StatefulWidget {
  final TextEditingController controller; // Передаём контроллер

  AddTaskName({required this.controller});

  @override
  State<AddTaskName> createState() => _AddTaskNameState();
}

class _AddTaskNameState extends State<AddTaskName> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: "Task name",
            hintStyle: TextStyle(fontWeight: FontWeight.bold), // Жирный текст
            filled: true,
            fillColor: Color.fromRGBO(242, 242, 242, 1), // Светлый фон
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20), // Закругленные углы
              borderSide: BorderSide.none, // Без рамки
            ),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          ),
        ));
  }
}
