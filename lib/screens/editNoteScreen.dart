// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:coursework/database.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

enum BlockType { text, image, audio }

class NoteBlock {
  final BlockType type;
  TextEditingController? controller;
  FocusNode? focusNode;
  File? file;

  NoteBlock.text([String initial = ''])
      : type = BlockType.text,
        controller = TextEditingController(text: initial),
        focusNode = FocusNode(),
        file = null;

  NoteBlock.image(this.file)
      : type = BlockType.image,
        controller = null,
        focusNode = null;

  NoteBlock.audio(this.file)
      : type = BlockType.audio,
        controller = null,
        focusNode = null;
}

class EditNoteScreen extends StatefulWidget {
  final Map<String, dynamic> note;
  const EditNoteScreen({Key? key, required this.note}) : super(key: key);

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late List<NoteBlock> blocks;
  int? noteId;
  late int noteColor;

  @override
  void initState() {
    super.initState();
    noteId = widget.note['id'] as int?;
    noteColor = widget.note['color'] as int? ?? Colors.white.value;
    blocks = _parseStoredText(widget.note['text'] as String? ?? '');
    for (var b in blocks) {
      if (b.type == BlockType.text) {
        b.controller!.addListener(_saveAll);
      }
    }
  }

  List<NoteBlock> _parseStoredText(String fullText) {
    final regex = RegExp(r'\[image:.*?\]|\[audio:.*?\]');
    final parts = fullText.split(regex).where((s) => s.isNotEmpty);
    final matches = regex.allMatches(fullText).toList();
    final blocks = <NoteBlock>[];

    for (int i = 0; i < parts.length; i++) {
      blocks.add(NoteBlock.text(parts.elementAt(i)));

      if (i < matches.length) {
        final m = matches[i].group(0)!;
        if (m.startsWith('[image:')) {
          final path = m.substring(7, m.length - 1);
          blocks.add(NoteBlock.image(File(path)));
        } else {
          final path = m.substring(7, m.length - 1);
          blocks.add(NoteBlock.audio(File(path)));
        }
      }
    }

    if (blocks.isEmpty) blocks.add(NoteBlock.text());

    return blocks;
  }

  Future<void> _saveAll() async {
    final fullText = blocks.map((b) {
      switch (b.type) {
        case BlockType.text:
          return b.controller!.text;
        case BlockType.image:
          return '[image:${b.file!.path}]';
        case BlockType.audio:
          return '[audio:${b.file!.path}]';
      }
    }).join('\n');

    final id = await MyDatabase().insertOrUpdateNote(
      id: noteId,
      text: fullText,
      color: noteColor,
    );
    if (noteId == null) setState(() => noteId = id);
  }

  Future<void> _insertImage(int idx) async {
    final XFile? img = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (img == null) return;
    final file = File(img.path);

    setState(() {
      blocks.insert(idx + 1, NoteBlock.image(file));
      blocks.insert(idx + 2, NoteBlock.text());
      blocks[idx + 2].controller!.addListener(_saveAll);
    });
    Future.delayed(Duration(milliseconds: 100),
        () => blocks[idx + 2].focusNode!.requestFocus());
    _saveAll();
  }

  Future<void> _insertAudio(int idx) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result == null || result.files.isEmpty) return;
    final path = result.files.first.path;
    if (path == null) return;
    final file = File(path);

    setState(() {
      blocks.insert(idx + 1, NoteBlock.audio(file));
      blocks.insert(idx + 2, NoteBlock.text());
      blocks[idx + 2].controller!.addListener(_saveAll);
    });
    Future.delayed(Duration(milliseconds: 100),
        () => blocks[idx + 2].focusNode!.requestFocus());
    _saveAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 100.h,
            width: double.infinity,
            color: Color(noteColor),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 50.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Icon(Icons.arrow_back_ios_new,
                          color: Color(noteColor)),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  IconButton(
                    icon: Icon(Icons.text_fields, color: Colors.white),
                    onPressed: () {
                      final idx = blocks.length - 1;
                      setState(() {
                        blocks.add(NoteBlock.text());
                        blocks.last.controller!.addListener(_saveAll);
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.image, color: Colors.white),
                    onPressed: () => _insertImage(blocks.length - 1),
                  ),
                  IconButton(
                    icon: Icon(Icons.mic, color: Colors.white),
                    onPressed: () => _insertAudio(blocks.length - 1),
                  ),
                ]),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: ListView.builder(
                itemCount: blocks.length,
                itemBuilder: (ctx, i) {
                  final b = blocks[i];
                  switch (b.type) {
                    case BlockType.text:
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: TextField(
                          controller: b.controller,
                          focusNode: b.focusNode,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Текст…',
                            border: InputBorder.none,
                          ),
                        ),
                      );
                    case BlockType.image:
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Image.file(
                          b.file!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      );
                    case BlockType.audio:
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Row(children: [
                          Icon(Icons.audiotrack, size: 32.sp),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              b.file!.path.split('/').last,
                              style: TextStyle(fontSize: 16.sp),
                            ),
                          ),
                        ]),
                      );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
