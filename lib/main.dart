// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:coursework/notesScreen.dart';
import 'package:coursework/widgets/TasksScreen/anotherDatesWidget.dart';

import 'addTaskSreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'widgets/datesWidget.dart';
import 'widgets/TasksScreen/addButtonWidget.dart';
import 'widgets/TasksScreen/menuButtonWidget.dart';
import 'widgets/TasksScreen/tasksWidget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final DateTime? isAnotherDate;
  HomeScreen({this.isAnotherDate});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    return Scaffold(
      body: Stack(
        children: [
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
          Positioned(
            top: 45,
            left: 6,
            child: Builder(
              builder: (context) => Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    child: const MenuButton(),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              top: 55,
              right: 13,
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
            top: 110,
            left: 15,
            child: Text("$monthName, $year",
                style: TextStyle(color: Colors.white, fontSize: 22)),
          ),
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 80,
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
              top: MediaQuery.of(context).size.height * 0.33,
              left: 10,
              right: 10,
              child: TasksWidget(
                key: _tasksWidgetKey,
                selectedDate: _selectedDate,
                refreshTasks: _refreshTasks,
              )),
        ],
      ),
      drawer: SizedBox(
        width: 70,
        child: Drawer(
          child: Container(
            color: Color(0xFF4043C9),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: 70,
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
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.white.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
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
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
