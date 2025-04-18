// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api
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
          Positioned(top: 45, left: 6, child: MenuButton()),
          Positioned(
              top: 55,
              right: 13,
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AddTaskScreen(refreshTasks: _refreshTasks)),
                    ).then((_) {
                      _refreshTasks(); // ✅ вызывается только после возврата с AddTaskScreen
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
              child: DatesWidget(
                initialDate: _selectedDate,
                onDateSelected: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                  // можешь передать дату в TasksWidget или отфильтровать задачи тут
                },
              ),
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.32,
              left: 15,
              child: Text("Today's task",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.33,
              left: 10,
              right: 10,
              child: TasksWidget(
                  key: _tasksWidgetKey, selectedDate: _selectedDate))
        ],
      ),
    );
  }
}
