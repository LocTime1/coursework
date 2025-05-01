// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, library_private_types_in_public_api, file_names, use_build_context_synchronously

import 'dart:developer';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  final DateTime selectedDate;

  AddTaskScreen({required this.refreshTasks, required this.selectedDate});
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  DateTime? selectedDate;
  Color? _selectedColor;
  final TextEditingController _taskNameController = TextEditingController();
  TimeOfDay? _selectedTime;
  @override
  void initState() {
    selectedDate = widget.selectedDate;
    super.initState();
  }

  void _saveTask() async {
    await MyDatabase().insertTask({
      'title': _taskNameController.text,
      'date': selectedDate!.toIso8601String(),
      'deadline': _selectedTime!.format(context),
      'color': _selectedColor!.value,
      'completed': 0,
    });
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
                top: 250.h,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  height: 641.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.r),
                      topRight: Radius.circular(40.r),
                    ),
                  ),
                ),
              ),
              Positioned(top: 60.h, left: 15.w, child: MyBackButton()),
              Positioned(
                  top: 145.h,
                  left: 25.w,
                  child: Text(
                    "Add Task",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35.sp,
                        fontWeight: FontWeight.bold),
                  )),
              Positioned(
                  top: 270.h,
                  left: 0,
                  right: 0,
                  child: SizedBox(height: 80.h, child: MonthScrollWidget())),
              Positioned(
                  top: 340.h,
                  left: 0,
                  right: 0,
                  child: ChooseDatesWidget(
                    selectedDate: selectedDate,
                    onDateSelected: (date) {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                  )),
              Positioned(
                  top: 460.h,
                  left: 20.w,
                  child: Text("Task Name",
                      style: TextStyle(
                          fontSize: 27.sp, fontWeight: FontWeight.bold))),
              Positioned(
                  top: 510.h,
                  left: 20.w,
                  right: 20.w,
                  child: AddTaskName(
                    controller: _taskNameController,
                  )),
              Positioned(
                  top: 580.h,
                  left: 20.w,
                  child: MyTimeWidget(
                    selectedTime: _selectedTime,
                    onTimeSelected: (time) {
                      setState(() {
                        _selectedTime = time;
                      });
                    },
                  )),
              Positioned(
                top: 680.h,
                left: 20.w,
                child: Text("Color",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 27.sp)),
              ),
              Positioned(
                  top: 720.h,
                  left: 20.w,
                  child: ColorPickerDemo(
                    selectedColor: _selectedColor,
                    onColorSelected: (color) {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                  )),
              Positioned(
                  top: 780.h,
                  right: 30.w,
                  child: GestureDetector(
                    onTap: () {
                      if (_taskNameController.text.isEmpty ||
                          selectedDate == null ||
                          _selectedTime == null ||
                          _selectedColor == null) {
                        _showTopMessage(
                            context, "Not all fields are filled in");
                      } else {
                        log("Название: ${_taskNameController.text}");
                        log("Дата: $selectedDate");
                        log("Дедлайн: $_selectedTime");
                        log("Цвет: $_selectedColor");
                        _saveTask();
                      }
                    },
                    child: Container(
                      height: 80.h,
                      width: 130.w,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(89, 95, 255, 1),
                          borderRadius: BorderRadius.circular(25.r)),
                      child: Center(
                        child: Text(
                          "Add",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.sp,
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
        top: 50.h, // Отступ сверху
        left: 41.1.w,
        width: 330.w,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
            decoration: BoxDecoration(
              color: Color.fromRGBO(228, 123, 105, 1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: Text(
                message,
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
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
