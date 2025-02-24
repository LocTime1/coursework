// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
          )),
      Positioned(
          top: 270,
          left: 0,
          right: 0,
          child: SizedBox(height: 80, child: MonthScrollWidget()))
    ]));
  }
}

class MonthScrollWidget extends StatefulWidget {
  @override
  _MonthScrollWidgetState createState() => _MonthScrollWidgetState();
}

class _MonthScrollWidgetState extends State<MonthScrollWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    List<String> months = _getMonths();

    int todayIndex =
        months.indexWhere((mon) => mon == DateFormat('MMM yyyy').format(now));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        double offset =
            todayIndex * 150.0 - MediaQuery.of(context).size.width / 2 + 75.0;
        _scrollController.animateTo(offset,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    });

    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal, // Горизонтальная прокрутка
      child: Row(
        children: months.map((month) => _buildContainer(month, now)).toList(),
      ),
    );
  }

  Widget _buildContainer(String month, DateTime currentDate) {
    bool isMonthNow = DateFormat('MMM yyyy').format(currentDate) == month;
    return Container(
      width: 100,
      height: 130,
      margin: EdgeInsets.symmetric(horizontal: 25),
      // decoration: BoxDecoration(
      //   color: Colors.blueAccent,
      //   borderRadius: BorderRadius.circular(10),
      // ),
      child: Center(
        child: Text(
          month,
          style: TextStyle(
              fontSize: 22,
              color: isMonthNow ? Colors.black : Colors.grey,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  List<String> _getMonths() {
    List<String> months = [];
    DateTime now = DateTime.now();
    for (int i = -12; i <= 12; i++) {
      DateTime month = DateTime(now.year, now.month + i);
      String formattedMonth =
          DateFormat('MMM yyyy').format(month); // Месяц с годом
      months.add(formattedMonth);
    }
    return months;
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
