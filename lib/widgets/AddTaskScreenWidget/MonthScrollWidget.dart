// ignore_for_file: file_names, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      scrollDirection: Axis.horizontal,
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
      String formattedMonth = DateFormat('MMM yyyy').format(month);
      months.add(formattedMonth);
    }
    return months;
  }
}
