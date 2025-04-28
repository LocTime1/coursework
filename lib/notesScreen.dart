// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:coursework/main.dart';
import 'package:flutter/material.dart';

import 'widgets/TasksScreen/menuButtonWidget.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(128, 200, 194, 1),
      body: Stack(children: [
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
                MaterialPageRoute(builder: (context) => HomeScreen()),
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
