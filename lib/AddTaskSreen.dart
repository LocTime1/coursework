// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:coursework/widgets/AddTaskScreenWidget/ChooseDateWidget.dart';
import 'package:coursework/widgets/AddTaskScreenWidget/ColorButton.dart';
import 'package:flutter/material.dart';
import 'widgets/AddTaskScreenWidget/AddTaskName.dart';
import 'widgets/AddTaskScreenWidget/MonthScrollWidget.dart';
import 'widgets/AddTaskScreenWidget/MyTimeWidget.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  DateTime? _selectedDate = DateTime.now();
  Color? _selectedColor;
  final TextEditingController _taskNameController = TextEditingController();
  TimeOfDay? _selectedTime;
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
              // Фон
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height, // Исправлено
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
              Positioned(top: 60, left: 15, child: BackButton()),
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
                    selectedDate: _selectedDate, // Передаём текущую дату
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate =
                            date; // Теперь обновляем дату в родителе
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
                    selectedTime: _selectedTime, // Передаём текущую дату
                    onTimeSelected: (time) {
                      setState(() {
                        _selectedTime =
                            time; // Теперь обновляем дату в родителе
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
                    selectedColor: _selectedColor, // Передаём текущую дату
                    onColorSelected: (color) {
                      setState(() {
                        _selectedColor =
                            color; // Теперь обновляем дату в родителе
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
                        _showTopMessage(context,
                            "Not all fields are filled in"); // Вывод ошибки
                      } else {
                        print("Название: ${_taskNameController.text}");
                        print("Дата: $_selectedDate");
                        print("Дедлайн: $_selectedTime");
                        print("Цвет: $_selectedColor");
                        Navigator.pop(context);
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
              color: Color.fromRGBO(228, 123, 105, 1), // Цвет ошибки
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

    // Удаление сообщения через 2 секунды
    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}

class BackButton extends StatelessWidget {
  const BackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Icon(
          Icons.arrow_back_ios_new,
          color: Color.fromRGBO(64, 67, 201, 1),
        ),
      ),
    );
  }
}
