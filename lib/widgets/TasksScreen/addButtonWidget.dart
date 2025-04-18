// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Icon(
        Icons.add,
        color: Color.fromRGBO(64, 67, 201, 1),
        size: 35,
      ),
    );
  }
}
