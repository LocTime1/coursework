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

  NoteBlock.text()
      : type = BlockType.text,
        controller = TextEditingController(),
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

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({Key? key}) : super(key: key);
  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  List<NoteBlock> blocks = [];
  int? noteId;
  final int color = const Color.fromRGBO(128, 200, 194, 1).value;

  @override
  void initState() {
    super.initState();
    blocks.add(NoteBlock.text());
    blocks.first.controller!.addListener(() => _saveAll());
  }

  Future<void> _saveAll() async {
    final fullText = blocks.map((b) {
      if (b.type == BlockType.text) return b.controller!.text;
      if (b.type == BlockType.image) return '[image:${b.file!.path}]';
      if (b.type == BlockType.audio) return '[audio:${b.file!.path}]';
      return '';
    }).join('\n');

    final id = await MyDatabase().insertOrUpdateNote(
      id: noteId,
      text: fullText,
      color: color,
    );
    if (noteId == null) setState(() => noteId = id);
  }

  Future<void> _insertImage(int idx) async {
    final XFile? img =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img == null) return;
    final file = File(img.path);

    setState(() {
      blocks.insert(idx + 1, NoteBlock.image(file));
      blocks.insert(idx + 2, NoteBlock.text());
      blocks[idx + 2].controller!.addListener(() => _saveAll());
    });
    Future.delayed(Duration(milliseconds: 100),
        () => blocks[idx + 2].focusNode!.requestFocus());
    _saveAll();
  }

  Future<void> _insertAudio(int idx) async {
    final res = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (res == null || res.files.isEmpty) return;
    final file = File(res.files.first.path!);

    setState(() {
      blocks.insert(idx + 1, NoteBlock.audio(file));
      blocks.insert(idx + 2, NoteBlock.text());
      blocks[idx + 2].controller!.addListener(() => _saveAll());
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
            color: Color(color),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 50.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child:
                            Icon(Icons.arrow_back_ios_new, color: Color(color)),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    IconButton(
                      icon: Icon(Icons.text_fields, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          blocks.add(NoteBlock.text());
                          blocks.last.controller!.addListener(() => _saveAll());
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
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
                            hintText: 'Текст...',
                            border: InputBorder.none,
                          ),
                        ),
                      );
                    case BlockType.image:
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Image.file(b.file!),
                      );
                    case BlockType.audio:
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Row(
                          children: [
                            Icon(Icons.audiotrack, size: 32),
                            SizedBox(width: 12.w),
                            Expanded(child: Text(b.file!.path.split('/').last)),
                          ],
                        ),
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
