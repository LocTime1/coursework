// ignore_for_file: file_names, library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnotherDateswidget extends StatelessWidget {
  final DateTime date;
  const AnotherDateswidget({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 15,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: 140,
            height: 100,
            margin: EdgeInsets.symmetric(horizontal: 7),
            decoration: BoxDecoration(
              color: Color.fromRGBO(89, 95, 255, 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
                child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 25,
                ),
                Text(
                  "Go back",
                  style: TextStyle(color: Colors.white, fontSize: 23),
                ),
              ],
            )),
          ),
        ),
        SizedBox(
          width: 15,
        ),
        Container(
            width: 200,
            height: 100,
            margin: EdgeInsets.symmetric(horizontal: 7),
            decoration: BoxDecoration(
              color: Color.fromRGBO(89, 95, 255, 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                DateFormat('MMM d, y').format(date),
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ))
      ],
    );
  }
}
