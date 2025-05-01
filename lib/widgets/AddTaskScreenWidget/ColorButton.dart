// ignore_for_file: file_names, use_super_parameters, library_private_types_in_public_api, prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ColorPickerButton extends StatefulWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const ColorPickerButton({
    Key? key,
    required this.color,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  _ColorPickerButtonState createState() => _ColorPickerButtonState();
}

class _ColorPickerButtonState extends State<ColorPickerButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color,
          border: widget.isSelected
              ? Border.all(color: Color.fromRGBO(64, 67, 201, 1), width: 5.w)
              : null,
        ),
      ),
    );
  }
}

class ColorPickerDemo extends StatefulWidget {
  final Color? selectedColor;
  final Function(Color) onColorSelected;
  ColorPickerDemo({required this.selectedColor, required this.onColorSelected});
  @override
  _ColorPickerDemoState createState() => _ColorPickerDemoState();
}

class _ColorPickerDemoState extends State<ColorPickerDemo> {
  late Color? _selectedColor;
  final List<Color> colors = [
    Color.fromRGBO(166, 152, 237, 1),
    Color.fromRGBO(127, 188, 249, 1),
    Color.fromRGBO(128, 200, 194, 1),
    Color.fromRGBO(235, 171, 159, 1),
  ];

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.selectedColor;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: colors.map((color) {
        return Padding(
          padding: EdgeInsets.all(8.w),
          child: ColorPickerButton(
            color: color,
            isSelected: _selectedColor == color,
            onTap: () {
              setState(() {
                _selectedColor = color;
              });
              widget.onColorSelected(color);
            },
          ),
        );
      }).toList(),
    );
  }
}
