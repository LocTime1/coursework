// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, use_super_parameters, file_names

import 'dart:developer';

import 'package:coursework/database.dart';
import 'package:flutter/material.dart';

class TasksWidget extends StatefulWidget {
  final DateTime selectedDate;

  const TasksWidget({Key? key, required this.selectedDate}) : super(key: key);

  @override
  TasksWidgetState createState() => TasksWidgetState();
}

class TasksWidgetState extends State<TasksWidget> {
  List<Map<String, dynamic>> tasks = [];

  void loadTasks() async {
    log("Вызван loadTasks()");
    final data = await MyDatabase().getTasks();
    log("Все задачи:");
    for (var task in data) {
      log("ID: ${task['id']} — ${task['title']} — ${task['date']}");
    }

    final filtered = data.where((task) {
      final taskDateStr = task['date'];
      if (taskDateStr == null) return false;

      final taskDate = DateTime.tryParse(taskDateStr);
      if (taskDate == null) return false;

      return taskDate.year == widget.selectedDate.year &&
          taskDate.month == widget.selectedDate.month &&
          taskDate.day == widget.selectedDate.day;
    }).toList();

    setState(() {
      tasks = filtered;
    });
  }

  @override
  void didUpdateWidget(covariant TasksWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedDate != widget.selectedDate) {
      loadTasks();
    }
  }

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.72,
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      int newStatus = task["isCompleted"] == 1 ? 0 : 1;

                      await MyDatabase()
                          .updateTaskCompletion(task['id'], newStatus);

                      loadTasks();
                    },
                    child: task["isCompleted"] == 1
                        ? Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Color(task['color']),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.check,
                                color: Colors.white, size: 23),
                          )
                        : Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(task['color']),
                                width: 7,
                              ),
                            ),
                          ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Container(
                    width: 2,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          width: 2,
                          style: BorderStyle.none,
                        ),
                      ),
                    ),
                    child: CustomPaint(
                      painter: DashedLinePainter(color: task['color']),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  )
                ],
              ),
              Container(
                width: 315,
                height: 145,
                decoration: BoxDecoration(
                    color: Color(task['color']).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(25)),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "${task['deadline']}",
                          style: TextStyle(
                              color: Color.fromRGBO(75, 76, 90, 1),
                              fontSize: 17),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "${task['title']}",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 270,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                  onTap: () async {
                                    await MyDatabase().deleteTask(task['id']);
                                    loadTasks();
                                  },
                                  child: Container(
                                      height: 40,
                                      width: 70,
                                      decoration: BoxDecoration(
                                          color: Color(task['color']),
                                          borderRadius:
                                              BorderRadius.circular(35)),
                                      child: Center(
                                        child: Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )))
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  int color;
  DashedLinePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color(color)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    double dashHeight = 5, dashSpace = 5;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
