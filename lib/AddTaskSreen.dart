// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      // Фон
      Container(
        width: double.infinity,
        height: double.infinity,
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
                color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
          ))
    ]));
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
