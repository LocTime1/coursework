// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    int year = now.year;
    String monthName = DateFormat('MMMM').format(now);
    return Scaffold(
      body: Stack(
        children: [
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
          Positioned(top: 45, left: 6, child: MenuButton()),
          Positioned(top: 55, right: 13, child: AddButton()),
          Positioned(
            top: 110,
            left: 15,
            child: Text("$monthName, $year",
                style: TextStyle(color: Colors.white, fontSize: 22)),
          ),
          Positioned(
            top: 150,
            left: 0,
            right: 0, // Добавляем ограничения по ширине
            child: SizedBox(
              height: 80, // Высота контейнера с датами
              child: DatesWidget(),
            ),
          ),
        ],
      ),
    );
  }
}

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

    // Вычисляем индекс текущей даты
    int todayIndex = dates.indexWhere((date) =>
        date.year == now.year &&
        date.month == now.month &&
        date.day == now.day);

    // Прокручиваем к текущей дате после сборки
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        // Сдвигаем позицию так, чтобы текущая дата была по центру
        double offset =
            todayIndex * 86.0 - MediaQuery.of(context).size.width / 2 + 70.0;
        _scrollController.animateTo(offset,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    });

    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal, // Горизонтальная прокрутка
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Центрируем список
        children: dates.map((date) => _buildContainer(date, now)).toList(),
      ),
    );
  }

  List<DateTime> _getDates(DateTime currentDate) {
    List<DateTime> dates = [];
    for (int i = -7; i <= 7; i++) {
      // Показываем 7 дней до и 7 после текущей даты
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
      height: 100, // Увеличиваем высоту, чтобы добавить день недели
      margin: EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        color: isToday ? Colors.white : Color.fromRGBO(89, 95, 255, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Сокращённое название дня недели
          Text(
            DateFormat('E')
                .format(date)
                .toUpperCase(), // Сокращение дня недели (например, "Mon", "Tue")
            style: TextStyle(
              color: isToday ? Color.fromRGBO(89, 95, 255, 1) : Colors.white,
              fontSize: 14, // Меньший размер шрифта для дня недели
            ),
          ),
          // Число
          Text(
            DateFormat('d').format(date), // Отображаем только число
            style: TextStyle(
              color: isToday
                  ? Color.fromRGBO(89, 95, 255, 1)
                  : Colors.white, // Белый для текущего дня
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 60,
        height: 80,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(top: 18, left: 15, child: _line()),
            Positioned(top: 28, child: _line(longer: true)),
            Positioned(top: 38, right: 15, child: _line()),
          ],
        ));
  }

  Widget _line({bool longer = false}) {
    return Container(
      width: longer ? 25 : 13, // Средняя полоска длиннее
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white, // Цвет полосок
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Icon(
        Icons.add,
        color: Color.fromRGBO(64, 67, 201, 1),
        size: 35,
      ),
    );
  }
}
