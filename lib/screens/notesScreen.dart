// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:coursework/database.dart';
import 'package:coursework/screens/addNoteScreen.dart';
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
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    final data = await MyDatabase().getNotes();
    log("${data}");
    setState(() {
      notes = data;
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(128, 200, 194, 1),
      body: Stack(
        children: [
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
                  child: SizedBox(
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
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddNoteScreen()),
                );
                loadNotes(); 
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons.add,
                  color: Color.fromRGBO(128, 200, 194, 1),
                  size: 35,
                ),
              ),
            ),
          ),
          Positioned(
            top: 110,
            left: 65,
            child: Text(
              " Your notes",
              style: TextStyle(color: Colors.white, fontSize: 53),
            ),
          ),
          Positioned(
            top: 200,
            left: MediaQuery.of(context).size.width * 0.05,
            child: SizedBox(
              height: 700,
              width: MediaQuery.of(context).size.width * 0.9,
              child: MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  final color = Color(note['color'] ?? Colors.white);

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddNoteScreen()));
                    },
                    child: Container(
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
                          if ((note['text'] ?? '').isNotEmpty)
                            Text(
                              note['text'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          SizedBox(height: 6),
                          if (note['createdAt'] != null)
                            Text(
                              note['createdAt'].toString().split('T').first,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
      drawer: SizedBox(
        width: 70,
        child: Drawer(
          child: Container(
            color: Color.fromRGBO(128, 200, 194, 1),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(height: 70),
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
