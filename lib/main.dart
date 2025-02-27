// ignore_for_file: prefer_const_constructors

import 'package:coursework/AddTaskSreen.dart';
import 'package:coursework/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'widgets/DatesWidget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<TasksWidgetState> _tasksWidgetKey = GlobalKey();
  void _refreshTasks() {
    _tasksWidgetKey.currentState?._loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    int year = now.year;
    String monthName = DateFormat('MMMM').format(now);
    return Scaffold(
      body: Stack(
        children: [
          // Фон
          Container(
            width: double.infinity,
            height: double.infinity,
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
          Positioned(top: 45, left: 6, child: MenuButton()),
          Positioned(
              top: 55,
              right: 13,
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AddTaskScreen(refreshTasks: _refreshTasks)),
                    );
                    _refreshTasks();
                  },
                  child: AddButton())),
          Positioned(
            top: 110,
            left: 15,
            child: Text("$monthName, $year",
                style: TextStyle(color: Colors.white, fontSize: 22)),
          ),
          Positioned(
            top: 150,
            left: 0,
            right: 0, // Добавляем ограничения по ширине
            child: SizedBox(
              height: 80, // Высота контейнера с датами
              child: DatesWidget(),
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.32,
              left: 15,
              child: Text("Today's task",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.33,
              left: 10,
              right: 10,
              child: TasksWidget(key: _tasksWidgetKey))
        ],
      ),
    );
  }
}

class TasksWidget extends StatefulWidget {
  const TasksWidget({Key? key}) : super(key: key);

  @override
  TasksWidgetState createState() => TasksWidgetState();
}

class TasksWidgetState extends State<TasksWidget> {
  List<Map<String, dynamic>> tasks = [];

  void _loadTasks() async {
    final data = await MyDatabase().getTasks();
    setState(() {
      tasks = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.72,
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  // Круглая иконка с галочкой
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color(task['color']), // Цвет круга
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, color: Colors.white, size: 23),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  // Пунктирная линия
                  Container(
                    width: 2,
                    height: 100, // Высота линии
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          width: 2,
                          style: BorderStyle.none,
                        ),
                      ),
                    ),
                    child: CustomPaint(
                      painter: DashedLinePainter(color: task['color']),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  )
                ],
              ),
              Container(
                width: 315,
                height: 145,
                decoration: BoxDecoration(
                    color: Color(task['color']),
                    borderRadius: BorderRadius.circular(25)),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "${task['deadline']}",
                          style: TextStyle(
                              color: Color.fromRGBO(75, 76, 90, 1),
                              fontSize: 17),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "${task['title']}",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                                onTap: () {},
                                child: Container(
                                  height: 30,
                                  width: 40,
                                  decoration:
                                      BoxDecoration(color: Colors.purple),
                                ))
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
          // task['title'], task['date'].split('T')[0], Color(task['color']
        },
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  int color;
  DashedLinePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color(color)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    double dashHeight = 5, dashSpace = 5;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

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
      width: longer ? 25 : 13, // Средняя полоска длиннее
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white, // Цвет полосок
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Icon(
        Icons.add,
        color: Color.fromRGBO(64, 67, 201, 1),
        size: 35,
      ),
    );
  }
}
