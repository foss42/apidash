// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: SDUIWidget())),
    );
  }
}

class SDUIWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFE0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Dog Emojis",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 20),
            Table(
              columnWidths: {
                0: FixedColumnWidth(200),
                1: FixedColumnWidth(250),
                2: FixedColumnWidth(250),
                3: FixedColumnWidth(100),
              },
              defaultColumnWidth: FlexColumnWidth(1),
              textDirection: TextDirection.ltr,
              defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
              border: TableBorder.all(
                color: const Color(0xFF428AF5),
                width: 1.0,
                borderRadius: BorderRadius.circular(16),
              ),
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 10),
                        child: Container(
                          color: const Color(0xFFFFFF00),
                          height: 50.0,
                          child: Center(
                            child: Text(
                              "Name",
                              style: TextStyle(fontSize: 21.84),
                            ),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 10),
                        child: Container(
                          color: const Color(0xFFFFFF00),
                          height: 50.0,
                          child: Center(
                            child: Text(
                              "Category",
                              style: TextStyle(fontSize: 21.84),
                            ),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 10),
                        child: Container(
                          color: const Color(0xFFFFFF00),
                          height: 50.0,
                          child: Center(
                            child: Text(
                              "Group",
                              style: TextStyle(fontSize: 21.84),
                            ),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 10),
                        child: Container(
                          color: const Color(0xFFFFFF00),
                          height: 50.0,
                          child: Center(
                            child: Text(
                              "Emoji",
                              style: TextStyle(fontSize: 21.84),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 10),
                        child: Center(
                          child: Text(
                            "dog face",
                            style: TextStyle(fontSize: 21.84),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 10),
                        child: Center(
                          child: Text(
                            "animals and nature",
                            style: TextStyle(fontSize: 21.84),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 10),
                        child: Center(
                          child: Text(
                            "animal mammal",
                            style: TextStyle(fontSize: 21.84),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 10),
                        child: Center(
                          child: Text(
                            "🐶",
                            style: TextStyle(fontSize: 30.576),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 10),
                        child: Center(
                          child: Text(
                            "dog",
                            style: TextStyle(fontSize: 21.84),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 10),
                        child: Center(
                          child: Text(
                            "animals and nature",
                            style: TextStyle(fontSize: 21.84),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 10),
                        child: Center(
                          child: Text(
                            "animal mammal",
                            style: TextStyle(fontSize: 21.84),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 10),
                        child: Center(
                          child: Text(
                            "🐕",
                            style: TextStyle(fontSize: 30.576),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 10),
                        child: Center(
                          child: Text(
                            "hot dog",
                            style: TextStyle(fontSize: 21.84),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 10),
                        child: Center(
                          child: Text(
                            "food and drink",
                            style: TextStyle(fontSize: 21.84),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 10),
                        child: Center(
                          child: Text(
                            "food prepared",
                            style: TextStyle(fontSize: 21.84),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 10),
                        child: Center(
                          child: Text(
                            "🌭",
                            style: TextStyle(fontSize: 30.576),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
