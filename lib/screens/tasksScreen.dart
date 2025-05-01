import 'package:coursework/screens/notesScreen.dart';
import 'package:coursework/widgets/TasksScreen/anotherDatesWidget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../addTaskSreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/datesWidget.dart';
import '../widgets/TasksScreen/addButtonWidget.dart';
import '../widgets/TasksScreen/menuButtonWidget.dart';
import '../widgets/TasksScreen/tasksWidget.dart';


class TasksScreen extends StatefulWidget {
  final DateTime? isAnotherDate;
  TasksScreen({this.isAnotherDate});
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  DateTime _selectedDate = DateTime.now();
  final GlobalKey<TasksWidgetState> _tasksWidgetKey = GlobalKey();
  void _refreshTasks() {
    _tasksWidgetKey.currentState?.loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    int year = now.year;
    String monthName = DateFormat('MMMM').format(now);
    print(MediaQuery.of(context).size);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
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
          Positioned(
            top: 45.h,
            left: 6.w,
            child: Builder(
              builder: (context) => Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.r),
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Container(
                    width: 60.h,
                    height: 60.w,
                    child: const MenuButton(),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              top: 55.h,
              right: 13.w,
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddTaskScreen(
                                refreshTasks: _refreshTasks,
                                selectedDate: _selectedDate,
                              )),
                    ).then((_) {
                      _refreshTasks();
                    });
                  },
                  child: AddButton())),
          Positioned(
            top: 110.h,
            left: 15.w,
            child: Text("$monthName, $year",
                style: TextStyle(color: Colors.white, fontSize: 22.sp)),
          ),
          Positioned(
            top: 150.h,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 80.h,
              child: widget.isAnotherDate == null
                  ? DatesWidget(
                      initialDate: _selectedDate,
                      onDateSelected: (date) {
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                    )
                  : AnotherDateswidget(date: widget.isAnotherDate!),
            ),
          ),
          Positioned(
              top: 280.h,
              left: 10.w,
              right: 10.w,
              child: TasksWidget(
                key: _tasksWidgetKey,
                selectedDate: _selectedDate,
                refreshTasks: _refreshTasks,
              )),
        ],
      ),
      drawer: SizedBox(
        width: 70.h,
        child: Drawer(
          child: Container(
            color: Color(0xFF4043C9),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: 70.h,
                ),
                _buildDrawerItem(Icons.task, 1, isSelected: true),
                _buildDrawerItem(Icons.alarm, 2),
                _buildDrawerItem(Icons.bar_chart, 3),
                _buildDrawerItem(Icons.settings, 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, int ind, {bool isSelected = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Container(
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.white.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: IconButton(
          onPressed: () {
            if (ind == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotesScreen()),
              );
            }
          },
          icon: Icon(
            icon,
            size: 30.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
