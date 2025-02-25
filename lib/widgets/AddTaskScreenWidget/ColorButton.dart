import 'package:flutter/material.dart';

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
        width: 40, // Размер круга
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color, // Основной цвет кнопки
          border: widget.isSelected
              ? Border.all(
                  color: Color.fromRGBO(64, 67, 201, 1),
                  width: 5) // Голубая рамка
              : null,
        ),
      ),
    );
  }
}

class ColorPickerDemo extends StatefulWidget {
  Color? selectedColor;
  final Function(Color) onColorSelected;
  ColorPickerDemo({required this.selectedColor, required this.onColorSelected});
  @override
  _ColorPickerDemoState createState() => _ColorPickerDemoState();
}

class _ColorPickerDemoState extends State<ColorPickerDemo> {
  final List<Color> colors = [
    Color.fromRGBO(166, 152, 237, 1),
    Color.fromRGBO(127, 188, 249, 1),
    Color.fromRGBO(128, 200, 194, 1),
    Color.fromRGBO(235, 171, 159, 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: colors.map((color) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ColorPickerButton(
            color: color,
            isSelected: widget.selectedColor == color,
            onTap: () {
              setState(() {
                widget.selectedColor = color;
              });
              widget.onColorSelected(color);
            },
          ),
        );
      }).toList(),
    );
  }
}
