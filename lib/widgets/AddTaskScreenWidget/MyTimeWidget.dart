import 'package:flutter/material.dart';

class MyTimeWidget extends StatefulWidget {
  final Function(TimeOfDay) onTimeSelected;
  final TimeOfDay? selectedTime; // Добавили параметр

  MyTimeWidget({required this.onTimeSelected, required this.selectedTime});

  @override
  State<MyTimeWidget> createState() => _MyTimeWidgetState();
}

class _MyTimeWidgetState extends State<MyTimeWidget> {
  final _formKey = GlobalKey<FormState>();
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = widget.selectedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Deadline",
            style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
        Form(
            key: _formKey,
            child: SizedBox(
              width: 150,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: selectedTime != null
                      ? selectedTime!.format(context)
                      : "Time",
                  hintStyle:
                      TextStyle(fontWeight: FontWeight.bold), // Жирный текст
                  filled: true,
                  fillColor: Color.fromRGBO(242, 242, 242, 1), // Светлый фон
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(20), // Закругленные углы
                    borderSide: BorderSide.none, // Без рамки
                  ),
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.access_time,
                      size: 30,
                    ), // Иконка часов

                    onPressed: () async {
                      TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: selectedTime ??
                            TimeOfDay.now(), // Начальное время — текущее
                      );

                      if (picked != null) {
                        setState(() {
                          selectedTime = picked;
                        });
                        widget.onTimeSelected(selectedTime!);
                        // Здесь можно обновить состояние и отобразить выбранное время в поле
                      }
                      ; // Здесь можно добавить диалог выбора времени
                    },
                  ), // Иконка часов
                ),
              ),
            ))
      ],
    );
  }
}
