// ignore_for_file: file_names, sized_box_for_whitespace

import 'package:flutter/material.dart';

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
      width: longer ? 25 : 13,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
