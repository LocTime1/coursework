// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, use_super_parameters, file_names, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:coursework/addTaskSreen.dart';
import 'package:coursework/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TasksWidget extends StatefulWidget {
  final DateTime selectedDate;
  final VoidCallback refreshTasks;

  const TasksWidget(
      {Key? key, required this.selectedDate, required this.refreshTasks})
      : super(key: key);

  @override
  TasksWidgetState createState() => TasksWidgetState();
}

class TasksWidgetState extends State<TasksWidget> {
  List<Map<String, dynamic>> tasks = [];
  List<Map<String, dynamic>> activeTasks = [];
  List<Map<String, dynamic>> completedTasks = [];

  void loadTasks() async {
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
      activeTasks = filtered.where((t) => t['isCompleted'] == 0).toList();
      completedTasks = filtered.where((t) => t['isCompleted'] == 1).toList();
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
    if (tasks.isEmpty) {
      return Container(
        padding: EdgeInsets.only(top: 100),
        height: 500,
        width: MediaQuery.of(context).size.width,
        child: Column(children: [
          Text(
            "Add something to do!",
            style: TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
          ),
          Lottie.asset("assets/animations/empty_animation.json", height: 200),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddTaskScreen(
                          refreshTasks: widget.refreshTasks,
                          selectedDate: widget.selectedDate,
                        )),
              ).then((_) {
                widget.refreshTasks();
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Color.fromRGBO(64, 67, 201, 1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_circle, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    "Add another task",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      );
    }
    DateTime today = DateTime.now();
    bool isToday = today.year == widget.selectedDate.year &&
        today.month == widget.selectedDate.month &&
        today.day == widget.selectedDate.day;
    if (activeTasks.isEmpty && completedTasks.isNotEmpty) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.65,
        child: ListView(
          padding: EdgeInsets.only(top: 0),
          children: [
            Column(
              children: [
                LottieBuilder.asset(
                  "assets/animations/first_animation.json",
                  height: 170,
                  repeat: false,
                ),
                Text(
                  "All tasks are done!",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddTaskScreen(
                                refreshTasks: widget.refreshTasks,
                                selectedDate: widget.selectedDate,
                              )),
                    ).then((_) {
                      widget.refreshTasks();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(64, 67, 201, 1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_circle, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          "Add another task",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: ExpansionTile(
                key: PageStorageKey(widget.selectedDate.toIso8601String()),
                title: Text(
                    "Completed tasks ${completedTasks.length}/${activeTasks.length + completedTasks.length}",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                children: completedTasks
                    .map((task) =>
                        TaskTile(task: task, onTaskChanged: loadTasks))
                    .toList(),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      child: ListView(
        padding: EdgeInsets.only(top: 10),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              isToday
                  ? "Today's tasks:"
                  : "Tasks for ${DateFormat('MMMM d').format(widget.selectedDate)}:",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          ...activeTasks
              .map((task) => TaskTile(task: task, onTaskChanged: loadTasks)),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: ExpansionTile(
              key: PageStorageKey(widget.selectedDate.toIso8601String()),
              title: Text(
                  "Completed tasks ${completedTasks.length}/${activeTasks.length + completedTasks.length}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
              children: completedTasks
                  .map((task) => TaskTile(task: task, onTaskChanged: loadTasks))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class TaskTile extends StatefulWidget {
  final Map<String, dynamic> task;
  final VoidCallback onTaskChanged;

  const TaskTile({
    required this.task,
    required this.onTaskChanged,
    super.key,
  });

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  late bool isCompleted;
  late dynamic task;

  @override
  void initState() {
    super.initState();
    task = widget.task;
    isCompleted = widget.task["isCompleted"] == 1;
  }

  void _toggleCompleted() async {
    int newStatus = isCompleted ? 0 : 1;

    await MyDatabase().updateTaskCompletion(widget.task['id'], newStatus);
    setState(() {
      isCompleted = !isCompleted;
    });

    widget.onTaskChanged();
  }

  void _deleteTask() async {
    await MyDatabase().deleteTask(widget.task['id']);
    widget.onTaskChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            GestureDetector(
              onTap: () async {
                _toggleCompleted();
              },
              child: task["isCompleted"] == 1
                  ? Container(
                      width: 30.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: Color(task['color']),
                        shape: BoxShape.circle,
                      ),
                      child:
                          Icon(Icons.check, color: Colors.white, size: 23.sp),
                    )
                  : Container(
                      width: 30.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color(task['color']),
                          width: 7.w,
                        ),
                      ),
                    ),
            ),
            SizedBox(
              height: 6.h,
            ),
            Container(
              width: 2.w,
              height: 100.h,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    width: 2.w,
                    style: BorderStyle.none,
                  ),
                ),
              ),
              child: CustomPaint(
                painter: DashedLinePainter(color: task['color']),
              ),
            ),
            SizedBox(
              height: 15.h,
            )
          ],
        ),
        Container(
          width: 315.w,
          height: 145.h,
          decoration: BoxDecoration(
              color: Color(task['color']).withOpacity(0.5),
              borderRadius: BorderRadius.circular(25.r)),
          child: Row(
            children: [
              SizedBox(
                width: 20.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15.h,
                  ),
                  Text(
                    "${task['deadline']}",
                    style: TextStyle(
                        color: Color.fromRGBO(75, 76, 90, 1), fontSize: 17.sp),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  SizedBox(
                    height: 35.h,
                    width: 290.w,
                    child: AutoSizeText(
                      task['title'],
                      style: TextStyle(
                          fontSize: 24.sp, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      minFontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    width: 270.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                            onTap: () async {
                              _deleteTask();
                            },
                            child: Container(
                                height: 40.h,
                                width: 70.w,
                                decoration: BoxDecoration(
                                    color: Color(task['color']),
                                    borderRadius: BorderRadius.circular(35.sp)),
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

    double dashHeight = 5.h, dashSpace = 5.h;
    double startY = 0.h;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
