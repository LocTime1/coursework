// ignore_for_file: file_names, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatesWidget extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime) onDateSelected;

  const DatesWidget({
    super.key,
    this.initialDate,
    required this.onDateSelected,
  });

  @override
  _DatesWidgetState createState() => _DatesWidgetState();
}

class _DatesWidgetState extends State<DatesWidget> {
  late ScrollController _scrollController;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    selectedDate = widget.initialDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    List<DateTime> dates = _getDates(now);

    int todayIndex = dates.indexWhere((date) =>
        date.year == selectedDate.year &&
        date.month == selectedDate.month &&
        date.day == selectedDate.day);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        double offset =
            todayIndex * 86.0 - MediaQuery.of(context).size.width / 2 + 70.0;
        _scrollController.animateTo(offset,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    });

    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: dates.map((date) => _buildContainer(date)).toList(),
      ),
    );
  }

  List<DateTime> _getDates(DateTime currentDate) {
    List<DateTime> dates = [];
    for (int i = -7; i <= 7; i++) {
      dates.add(currentDate.add(Duration(days: i)));
    }
    return dates;
  }

  Widget _buildContainer(DateTime date) {
    bool isSelected = date.year == selectedDate.year &&
        date.month == selectedDate.month &&
        date.day == selectedDate.day;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDate = date;
        });
        widget.onDateSelected(date);
      },
      child: Container(
        width: 70,
        height: 100,
        margin: EdgeInsets.symmetric(horizontal: 7),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Color.fromRGBO(89, 95, 255, 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('E').format(date).toUpperCase(),
              style: TextStyle(
                color:
                    isSelected ? Color.fromRGBO(89, 95, 255, 1) : Colors.white,
                fontSize: 14,
              ),
            ),
            Text(
              DateFormat('d').format(date),
              style: TextStyle(
                color:
                    isSelected ? Color.fromRGBO(89, 95, 255, 1) : Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
