// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:coursework/database.dart';
import 'package:coursework/screens/addNoteScreen.dart';
import 'package:coursework/screens/editNoteScreen.dart';
import 'package:coursework/screens/tasksScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../widgets/TasksScreen/menuButtonWidget.dart';

enum BlockType { text, image, audio }

class _Block {
  final BlockType type;
  final String data;
  _Block(this.type, this.data);
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Map<String, dynamic>> notes = [];
  int? selectedNoteId;

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    final data = await MyDatabase().getNotes();
    log("$data");
    setState(() => notes = data);
  }

  List<_Block> _parseBlocks(String text) {
    final regex = RegExp(r'\[image:(.*?)\]|\[audio:(.*?)\]');
    final matches = regex.allMatches(text).toList();
    final parts = text.split(regex);
    final blocks = <_Block>[];

    int matchIndex = 0;
    for (int i = 0; i < parts.length; i++) {
      final part = parts[i];
      if (part.isNotEmpty) {
        blocks.add(_Block(BlockType.text, part));
      }
      if (matchIndex < matches.length) {
        final m = matches[matchIndex];
        final img = m.group(1);
        final aud = m.group(2);
        if (img != null) {
          blocks.add(_Block(BlockType.image, img));
        } else if (aud != null) {
          blocks.add(_Block(BlockType.audio, aud));
        }
        matchIndex++;
      }
    }
    return blocks;
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
              height: MediaQuery.of(context).size.height * 0.77,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
            ),
          ),
          Positioned(
            top: 45,
            left: 6,
            child: Builder(
              builder: (ctx) => InkWell(
                onTap: () => Scaffold.of(ctx).openDrawer(),
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: const MenuButton(),
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
                  MaterialPageRoute(builder: (_) => const AddNoteScreen()),
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
                child: Icon(Icons.add,
                    color: Color.fromRGBO(128, 200, 194, 1), size: 35),
              ),
            ),
          ),
          Positioned(
            top: 110,
            left: 65,
            child: Text(
              "Your notes",
              style: TextStyle(color: Colors.white, fontSize: 53),
            ),
          ),
          Positioned(
            top: 230,
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05,
            bottom: 0,
            child: MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              itemCount: notes.length,
              itemBuilder: (ctx, index) {
                final note = notes[index];
                final bgColor = Color(note['color'] ?? Colors.white.value);

                final blocks = _parseBlocks(note['text'] as String? ?? '');

                final preview = <Widget>[];
                for (var b in blocks) {
                  if (preview.length >= 7) break;
                  switch (b.type) {
                    case BlockType.text:
                      preview.add(Text(
                        b.data.trim(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ));
                      break;
                    case BlockType.image:
                      preview.add(Row(
                        children: [
                          Icon(Icons.image, size: 20),
                          SizedBox(width: 4),
                          Text("Image",
                              style: TextStyle(
                                  fontSize: 14, fontStyle: FontStyle.italic)),
                        ],
                      ));
                      break;
                    case BlockType.audio:
                      preview.add(Row(
                        children: [
                          Icon(Icons.audiotrack, size: 20),
                          SizedBox(width: 4),
                          Text("Audio",
                              style: TextStyle(
                                  fontSize: 14, fontStyle: FontStyle.italic)),
                        ],
                      ));
                      break;
                  }
                  preview.add(SizedBox(height: 6));
                }

                final date = note['createdAt'] as String?;
                preview.add(Text(
                  date != null ? date.split('T').first : '',
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ));

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      ctx,
                      MaterialPageRoute(
                          builder: (_) => EditNoteScreen(note: note)),
                    );
                  },
                  onLongPressStart: (d) {
                    final tap = d.globalPosition;
                    final sz = MediaQuery.of(ctx).size;
                    showMenu<int>(
                      context: ctx,
                      position: RelativeRect.fromLTRB(tap.dx, tap.dy,
                          sz.width - tap.dx, sz.height - tap.dy),
                      items: [
                        PopupMenuItem(
                          value: 0,
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Удалить',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 8,
                    ).then((v) {
                      if (v == 0) {
                        MyDatabase().deleteNote(note['id']);
                        loadNotes();
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: bgColor.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(2, 2)),
                      ],
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: preview,
                    ),
                  ),
                );
              },
            ),
          ),
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
          icon: Icon(icon, size: 30, color: Colors.white),
          onPressed: () {
            if (ind == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TasksScreen()),
              );
            }
          },
        ),
      ),
    );
  }
}
