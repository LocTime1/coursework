// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Убирает отладочный баннер
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
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade300, // Верхний зелёный цвет
              Colors.white, // Плавный переход в белый
            ],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 60),
            MyAppBar(),
            SizedBox(height: 30),
            Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                AnalyzWidget(),
                SizedBox(
                  width: 20,
                ),
                AllMenus(),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Button()
          ],
        ),
      ),
    );
  }
}

class AllMenus extends StatelessWidget {
  const AllMenus({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 175,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Colors.green.shade200,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(3, 6),
              ),
            ],
          ),
          child: Center(
            child: Text(
              "Задачи на сегодня",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          width: 175,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Colors.green.shade200,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(3, 6),
              ),
            ],
          ),
          child: Center(
            child: Text(
              "Все задачи",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          width: 175,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Colors.green.shade200,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(3, 6),
              ),
            ],
          ),
          child: Center(
            child: Text(
              "Выполнено",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        )
      ],
    );
  }
}

class AnalyzWidget extends StatelessWidget {
  const AnalyzWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        // Отступ сверху (например, для статус-бара)
        width: 180,
        height: 420,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white, // Верхняя часть белая
              Colors.green.shade200, // Плавный переход в зелёный
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(3, 6),
            ),
          ],
        ));
  }
}

class MyAppBar extends StatelessWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        // Отступ сверху (например, для статус-бара)
        width: 380,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white, // Верхняя часть белая
              Colors.green.shade200, // Плавный переход в зелёный
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(3, 6),
            ),
          ],
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          // Кнопка Напоминания
          // Кнопка настройки
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.green.shade100,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(3, 6),
                ),
              ],
            ),
            child: Center(
              child: Icon(Icons.notifications, color: Colors.green, size: 40),
            ),
          ),

          // Кнопка "Tasks" (круглая)
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.green.shade100,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(3, 6),
                ),
              ],
            ),
            child: Center(
              child: Text(
                "Задачи",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),

          // Кнопка настройки
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.green.shade100,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(3, 6),
                ),
              ],
            ),
            child: Center(
              child: Icon(Icons.settings, color: Colors.green, size: 40),
            ),
          ),
        ]));
  }
}

class Button extends StatelessWidget {
  const Button({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 380,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white, // Верхняя часть белая
              Colors.green.shade200, // Плавный переход в зелёный
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(3, 6),
            ),
          ],
        ));
  }
}
