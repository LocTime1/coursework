// ignore_for_file: file_names, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddTaskName extends StatefulWidget {
  final TextEditingController controller;

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
            hintStyle: TextStyle(fontWeight: FontWeight.bold),
            filled: true,
            fillColor: Color.fromRGBO(242, 242, 242, 1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: BorderSide.none,
            ),
            isDense: true,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
          ),
        ));
  }
}
