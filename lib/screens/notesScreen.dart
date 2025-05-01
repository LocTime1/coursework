// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:coursework/screens/tasksScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../widgets/TasksScreen/menuButtonWidget.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final List<Map<String, String>> notes = [
    {
      'title': 'Курс по Flutter',
      'subtitle': 'Пройти раздел о сетках и адаптивности',
    },
    {
      'title': 'Список покупок',
      'subtitle':
          'Молоко, яйца, хлеб, сыр апааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааааа',
    },
    {
      'title': 'Заметки для курсовой',
      'subtitle': 'Введение и литература',
    },
    {
      'title': 'Позвонить Олегу',
      'subtitle': 'Обсудить поездку на выходные',
    },
    {
      'title': 'Написать кому-то',
      'subtitle': 'Обсудить поездку на выходные',
    },
    {
      'title': 'Позвонить маме',
      'subtitle': 'Обсудить поездку на выходные пп п папапаееаеаееа',
    },
    {
      'title': 'Пihsfdyyshfhousd',
      'subtitle':
          'Обсудить поездку на выходныеры ывраргывгапгывпгаывпашлнгывангшыванпывпашнпывапгщывнаишывнпагнывпншыпншапшнпш',
    },
  ];

  // Список доступных цветов
  final List<Color> availableColors = [
    // Color.fromRGBO(166, 152, 237, 1),
    // Color.fromRGBO(127, 188, 249, 1),
    // Color.fromRGBO(128, 200, 194, 1),
    // Color.fromRGBO(235, 171, 159, 1),
    Colors.white
  ];

  final Random random = Random();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(128, 200, 194, 1),
      body: Stack(children: [
        Positioned(
          top: MediaQuery.of(context).size.height * 0.23,
          left: 0,
          right: 0,
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.77,
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
                onTap: () {},
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Icon(
                    Icons.add,
                    color: Color.fromRGBO(128, 200, 194, 1),
                    size: 35,
                  ),
                ))),
        Positioned(
            top: 110,
            left: 65,
            child: Text(
              " Your notes",
              style: TextStyle(color: Colors.white, fontSize: 53),
            )),
        Positioned(
            top: 200,
            left: MediaQuery.of(context).size.width * 0.05,
            child: Container(
                height: 700,
                width: MediaQuery.of(context).size.width * 0.9,
                child: MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    final color =
                        availableColors[random.nextInt(availableColors.length)];
                    return Container(
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note['title']!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            note['subtitle']!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )))
      ]),
      drawer: SizedBox(
        width: 70,
        child: Drawer(
          child: Container(
            color: Color.fromRGBO(128, 200, 194, 1),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: 70,
                ),
                _buildDrawerItem(Icons.task, 1),
                _buildDrawerItem(Icons.alarm, 2, isSelected: true),
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
            if (ind == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TasksScreen()),
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
