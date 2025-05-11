// ignore_for_file: prefer_const_constructors

import 'package:coursework/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  late TextEditingController _controller;
  int? noteId;
  final int color = const Color.fromRGBO(128, 200, 194, 1).value;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    _controller.addListener(() {
      if (_controller.text.trim().isEmpty) return;

      MyDatabase().insertOrUpdateNote(
        id: noteId,
        text: _controller.text,
        color: color,
      ).then((id) {
        if (noteId == null) {
          setState(() {
            noteId = id;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 100.h,
            width: MediaQuery.of(context).size.width,
            color: Color(color),
            child: Padding(
              padding: EdgeInsets.only(top: 31.h),
              child: Row(
                children: [
                  SizedBox(width: 20.w),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 50.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Color(color),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(20.w),
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Введите текст заметки...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
