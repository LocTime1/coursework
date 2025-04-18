// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, library_private_types_in_public_api, file_names, use_build_context_synchronously

import 'dart:developer';

import 'database.dart';
import 'widgets/AddTaskScreenWidget/ChooseDateWidget.dart';
import 'widgets/AddTaskScreenWidget/ColorButton.dart';
import 'package:flutter/material.dart';
import 'widgets/AddTaskScreenWidget/AddTaskName.dart';
import 'widgets/AddTaskScreenWidget/MonthScrollWidget.dart';
import 'widgets/AddTaskScreenWidget/MyTimeWidget.dart';
import 'widgets/AddTaskScreenWidget/backButtonWidget.dart';

class AddTaskScreen extends StatefulWidget {
  final VoidCallback refreshTasks;

  AddTaskScreen({required this.refreshTasks});
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  DateTime? _selectedDate = DateTime.now();
  Color? _selectedColor;
  final TextEditingController _taskNameController = TextEditingController();
  TimeOfDay? _selectedTime;
  void _saveTask() async {
    await MyDatabase().insertTask({
      'title': _taskNameController.text,
      'date': _selectedDate!.toIso8601String(),
      'deadline': _selectedTime!.format(context),
      'color': _selectedColor!.value,
      'completed': 0,
    });
    widget.refreshTasks();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Stack(children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                color: Color.fromRGBO(64, 67, 201, 1),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.28,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.72,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                ),
              ),
              Positioned(top: 60, left: 15, child: MyBackButton()),
              Positioned(
                  top: 145,
                  left: 25,
                  child: Text(
                    "Add Task",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  )),
              Positioned(
                  top: 270,
                  left: 0,
                  right: 0,
                  child: SizedBox(height: 80, child: MonthScrollWidget())),
              Positioned(
                  top: 340,
                  left: 0,
                  right: 0,
                  child: ChooseDatesWidget(
                    selectedDate: _selectedDate,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                  )),
              Positioned(
                  top: 460,
                  left: 20,
                  child: Text("Task Name",
                      style: TextStyle(
                          fontSize: 27, fontWeight: FontWeight.bold))),
              Positioned(
                  top: 510,
                  left: 20,
                  right: 20,
                  child: AddTaskName(
                    controller: _taskNameController,
                  )),
              Positioned(
                  top: 580,
                  left: 20,
                  child: MyTimeWidget(
                    selectedTime: _selectedTime,
                    onTimeSelected: (time) {
                      setState(() {
                        _selectedTime = time;
                      });
                    },
                  )),
              Positioned(
                top: 680,
                left: 20,
                child: Text("Color",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 27)),
              ),
              Positioned(
                  top: 720,
                  left: 20,
                  child: ColorPickerDemo(
                    selectedColor: _selectedColor,
                    onColorSelected: (color) {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                  )),
              Positioned(
                  top: 780,
                  right: 30,
                  child: GestureDetector(
                    onTap: () {
                      if (_taskNameController.text.isEmpty ||
                          _selectedDate == null ||
                          _selectedTime == null ||
                          _selectedColor == null) {
                        _showTopMessage(
                            context, "Not all fields are filled in");
                      } else {
                        log("Название: ${_taskNameController.text}");
                        log("Дата: $_selectedDate");
                        log("Дедлайн: $_selectedTime");
                        log("Цвет: $_selectedColor");
                        _saveTask();
                      }
                    },
                    child: Container(
                      height: 80,
                      width: 130,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(89, 95, 255, 1),
                          borderRadius: BorderRadius.circular(25)),
                      child: Center(
                        child: Text(
                          "Add",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                  ))
            ]),
          ),
        ));
  }

  void _showTopMessage(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50, // Отступ сверху
        left: MediaQuery.of(context).size.width * 0.1,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
              color: Color.fromRGBO(228, 123, 105, 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                message,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}
