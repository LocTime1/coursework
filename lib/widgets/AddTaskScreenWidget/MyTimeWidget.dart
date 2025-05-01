// ignore_for_file: file_names, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTimeWidget extends StatefulWidget {
  final Function(TimeOfDay) onTimeSelected;
  final TimeOfDay? selectedTime;

  MyTimeWidget({required this.onTimeSelected, required this.selectedTime});

  @override
  State<MyTimeWidget> createState() => _MyTimeWidgetState();
}

class _MyTimeWidgetState extends State<MyTimeWidget> {
  final _formKey = GlobalKey<FormState>();
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = widget.selectedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Deadline",
            style: TextStyle(fontSize: 27.sp, fontWeight: FontWeight.bold)),
        Form(
            key: _formKey,
            child: SizedBox(
              width: 150.w,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: selectedTime != null
                      ? selectedTime!.format(context)
                      : "Time",
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
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.access_time,
                      size: 30.sp,
                    ),
                    onPressed: () async {
                      TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: selectedTime ?? TimeOfDay.now(),
                      );

                      if (picked != null) {
                        setState(() {
                          selectedTime = picked;
                        });
                        widget.onTimeSelected(selectedTime!);
                      }
                    },
                  ),
                ),
              ),
            ))
      ],
    );
  }
}
