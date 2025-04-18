// ignore_for_file: prefer_const_constructors, file_names, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChooseDatesWidget extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final DateTime? selectedDate;

  ChooseDatesWidget({required this.onDateSelected, required this.selectedDate});

  @override
  _ChooseDatesWidgetState createState() => _ChooseDatesWidgetState();
}

class _ChooseDatesWidgetState extends State<ChooseDatesWidget> {
  late ScrollController _scrollController;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    selectedDate = DateTime.now();
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

    int choosenIndex = dates.indexWhere((date) =>
        date.year == selectedDate!.year &&
        date.month == selectedDate!.month &&
        date.day == selectedDate!.day);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        double offset =
            choosenIndex * 86.0 - MediaQuery.of(context).size.width / 2 + 70.0;
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
    bool isChoose = selectedDate!.year == date.year &&
        selectedDate!.month == date.month &&
        selectedDate!.day == date.day;

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
            color: isChoose
                ? Color.fromRGBO(89, 95, 255, 1)
                : Color.fromRGBO(242, 242, 242, 1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat('E').format(date).toUpperCase(),
                style: TextStyle(
                  color: isChoose ? Colors.white : Colors.black,
                  fontSize: 14,
                ),
              ),
              Text(
                DateFormat('d').format(date),
                style: TextStyle(
                  color: isChoose ? Colors.white : Colors.black,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ));
  }
}
