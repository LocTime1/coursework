// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:coursework/widgets/ChooseDateWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Stack(children: [
              // Фон
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height, // Исправлено
                color: Color.fromRGBO(64, 67, 201, 1),
              ),
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
              Positioned(top: 60, left: 15, child: BackButton()),
              Positioned(
                  top: 145,
                  left: 25,
                  child: Text(
                    "Add Task",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  )),
              Positioned(
                  top: 270,
                  left: 0,
                  right: 0,
                  child: SizedBox(height: 80, child: MonthScrollWidget())),
              Positioned(
                  top: 340, left: 0, right: 0, child: ChooseDatesWidget()),
              Positioned(
                  top: 460,
                  left: 20,
                  child: Text("Task Name",
                      style: TextStyle(
                          fontSize: 27, fontWeight: FontWeight.bold))),
              Positioned(top: 510, left: 20, right: 20, child: AddTaskName()),
              Positioned(top: 580, left: 20, child: MyTimeWidget())
            ]),
          ),
        ));
  }
}

class MyTimeWidget extends StatefulWidget {
  const MyTimeWidget({super.key});

  @override
  State<MyTimeWidget> createState() => _MyTimeWidgetState();
}

class _MyTimeWidgetState extends State<MyTimeWidget> {
  final _formKey = GlobalKey<FormState>();

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
                  hintText: "Time",
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
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime:
                            TimeOfDay.now(), // Начальное время — текущее
                      );

                      if (pickedTime != null) {
                        print("Выбранное время: ${pickedTime.format(context)}");
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

class AddTaskName extends StatefulWidget {
  const AddTaskName({super.key});

  @override
  State<AddTaskName> createState() => _AddTaskNameState();
}

class _AddTaskNameState extends State<AddTaskName> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: TextFormField(
          decoration: InputDecoration(
            hintText: "Task name",
            hintStyle: TextStyle(fontWeight: FontWeight.bold), // Жирный текст
            filled: true,
            fillColor: Color.fromRGBO(242, 242, 242, 1), // Светлый фон
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20), // Закругленные углы
              borderSide: BorderSide.none, // Без рамки
            ),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          ),
        ));
  }
}

class MonthScrollWidget extends StatefulWidget {
  @override
  _MonthScrollWidgetState createState() => _MonthScrollWidgetState();
}

class _MonthScrollWidgetState extends State<MonthScrollWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    List<String> months = _getMonths();

    int todayIndex =
        months.indexWhere((mon) => mon == DateFormat('MMM yyyy').format(now));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        double offset =
            todayIndex * 150.0 - MediaQuery.of(context).size.width / 2 + 75.0;
        _scrollController.animateTo(offset,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    });

    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal, // Горизонтальная прокрутка
      child: Row(
        children: months.map((month) => _buildContainer(month, now)).toList(),
      ),
    );
  }

  Widget _buildContainer(String month, DateTime currentDate) {
    bool isMonthNow = DateFormat('MMM yyyy').format(currentDate) == month;
    return Container(
      width: 100,
      height: 130,
      margin: EdgeInsets.symmetric(horizontal: 25),
      // decoration: BoxDecoration(
      //   color: Colors.blueAccent,
      //   borderRadius: BorderRadius.circular(10),
      // ),
      child: Center(
        child: Text(
          month,
          style: TextStyle(
              fontSize: 22,
              color: isMonthNow ? Colors.black : Colors.grey,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  List<String> _getMonths() {
    List<String> months = [];
    DateTime now = DateTime.now();
    for (int i = -12; i <= 12; i++) {
      DateTime month = DateTime(now.year, now.month + i);
      String formattedMonth =
          DateFormat('MMM yyyy').format(month); // Месяц с годом
      months.add(formattedMonth);
    }
    return months;
  }
}

class BackButton extends StatelessWidget {
  const BackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Icon(
          Icons.arrow_back_ios_new,
          color: Color.fromRGBO(64, 67, 201, 1),
        ),
      ),
    );
  }
}
