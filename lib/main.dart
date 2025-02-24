// ignore_for_file: prefer_const_constructors

import 'package:coursework/AddTaskSreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'widgets/DatesWidget.dart';

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
          Positioned(
              top: 55,
              right: 13,
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddTaskScreen()),
                    );
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
