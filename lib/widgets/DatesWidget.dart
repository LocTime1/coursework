import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatesWidget extends StatefulWidget {
  const DatesWidget({super.key});

  @override
  _DatesWidgetState createState() => _DatesWidgetState();
}

class _DatesWidgetState extends State<DatesWidget> {
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
    List<DateTime> dates = _getDates(now);

    int todayIndex = dates.indexWhere((date) =>
        date.year == now.year &&
        date.month == now.month &&
        date.day == now.day);

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
        children: dates.map((date) => _buildContainer(date, now)).toList(),
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

  Widget _buildContainer(DateTime date, DateTime currentDate) {
    bool isToday = date.year == currentDate.year &&
        date.month == currentDate.month &&
        date.day == currentDate.day;

    return Container(
      width: 70,
      height: 100,
      margin: EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        color: isToday ? Colors.white : Color.fromRGBO(89, 95, 255, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('E').format(date).toUpperCase(),
            style: TextStyle(
              color: isToday ? Color.fromRGBO(89, 95, 255, 1) : Colors.white,
              fontSize: 14,
            ),
          ),
          Text(
            DateFormat('d').format(date),
            style: TextStyle(
              color: isToday ? Color.fromRGBO(89, 95, 255, 1) : Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
