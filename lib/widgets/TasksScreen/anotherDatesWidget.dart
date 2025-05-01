// ignore_for_file: file_names, library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnotherDateswidget extends StatelessWidget {
  final DateTime date;
  const AnotherDateswidget({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 15.h,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: 140.h,
            height: 100.w,
            margin: EdgeInsets.symmetric(horizontal: 7.w),
            decoration: BoxDecoration(
              color: Color.fromRGBO(89, 95, 255, 1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Center(
                child: Row(
              children: [
                SizedBox(
                  width: 10.h,
                ),
                Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 25.sp,
                ),
                Text(
                  "Go back",
                  style: TextStyle(color: Colors.white, fontSize: 23.sp),
                ),
              ],
            )),
          ),
        ),
        SizedBox(
          width: 15.h,
        ),
        Container(
            width: 200.w,
            height: 100.h,
            margin: EdgeInsets.symmetric(horizontal: 7.w),
            decoration: BoxDecoration(
              color: Color.fromRGBO(89, 95, 255, 1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Center(
              child: Text(
                DateFormat('MMM d, y').format(date),
                style: TextStyle(color: Colors.white, fontSize: 25.sp),
              ),
            ))
      ],
    );
  }
}
