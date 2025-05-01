// ignore_for_file: file_names, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 60.w,
        height: 80.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(top: 18.h, left: 15.w, child: _line()),
            Positioned(top: 28.h, child: _line(longer: true)),
            Positioned(top: 38.h, right: 15.w, child: _line()),
          ],
        ));
  }

  Widget _line({bool longer = false}) {
    return Container(
      width: longer ? 25.w : 13.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }
}
