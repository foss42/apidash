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
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: const Color(0xFFE6F7FF),
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              elevation: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Text(
                      "Word: flutter",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF00008B),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                    child: Text(
                      "Phonetic: /ˈflʌtə/",
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color(0xFF777777),
                      ),
                    ),
                  ),
                  Card(
                    color: const Color(0xFF676f8f),
                    margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                    elevation: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Text(
                            "Part of Speech: noun",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFFFFF00),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Card(
                              color: const Color(0xFF242838),
                              margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                              elevation: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 0),
                                    child: Text(
                                      "Definition: The act of fluttering; quick and irregular motion.",
                                      style: TextStyle(
                                        color: const Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 5, 10, 10),
                                    child: Text(
                                      "Example: the flutter of a fan",
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: const Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              color: const Color(0xFF242838),
                              margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                              elevation: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "Definition: A state of agitation.",
                                      style: TextStyle(
                                        color: const Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              color: const Color(0xFF242838),
                              margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                              elevation: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "Definition: An abnormal rapid pulsation of the heart.",
                                      style: TextStyle(
                                        color: const Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              color: const Color(0xFF242838),
                              margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                              elevation: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "Definition: A small bet or risky investment.",
                                      style: TextStyle(
                                        color: const Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              color: const Color(0xFF242838),
                              margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                              elevation: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "Definition: A hasty game of cards or similar.",
                                      style: TextStyle(
                                        color: const Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              color: const Color(0xFF242838),
                              margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                              elevation: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "Definition: (audio) The rapid variation of signal parameters, such as amplitude, phase, and frequency.",
                                      style: TextStyle(
                                        color: const Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Card(
                    color: const Color(0xFF676f8f),
                    margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                    elevation: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Text(
                            "Part of Speech: verb",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFFFFF00),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Card(
                              color: const Color(0xFF242838),
                              margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                              elevation: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 0),
                                    child: Text(
                                      "Definition: To flap or wave quickly but irregularly.",
                                      style: TextStyle(
                                        color: const Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 5, 10, 10),
                                    child: Text(
                                      "Example: flags fluttering in the wind",
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: const Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              color: const Color(0xFF242838),
                              margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                              elevation: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "Definition: Of a winged animal: to flap the wings without flying; to fly with a light flapping of the wings.",
                                      style: TextStyle(
                                        color: const Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              color: const Color(0xFF242838),
                              margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                              elevation: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 0),
                                    child: Text(
                                      "Definition: To cause something to flap.",
                                      style: TextStyle(
                                        color: const Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 5, 10, 10),
                                    child: Text(
                                      "Example: A bird flutters its wings.",
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: const Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              color: const Color(0xFF242838),
                              margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                              elevation: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "Definition: To drive into disorder; to throw into confusion.",
                                      style: TextStyle(
                                        color: const Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              color: const Color(0xFF242838),
                              margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                              elevation: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "Definition: To be in a state of agitation or uncertainty.",
                                      style: TextStyle(
                                        color: const Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              color: const Color(0xFF242838),
                              margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                              elevation: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "Definition: To be frivolous.",
                                      style: TextStyle(
                                        color: const Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
