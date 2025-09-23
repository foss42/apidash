// ignore_for_file: use_key_in_widget_constructors, use_full_hex_values_for_flutter_colors

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
      backgroundColor: const Color(0xFF303030),
      body: Column(
        children: [
          Text(
            "Different Dog Breeds",
            style: TextStyle(
              color: const Color(0xFFFF00),
              fontSize: 30.0,
            ),
          ),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              crossAxisCount: 3,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 1.0,
              children: [
                Card(
                  color: const Color(0xFFFFFFE0),
                  child: Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Card(
                              color: const Color(0xFFCCCAC0),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Name: Affenpinscher",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFFCCCAC0),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Description: The Affenpinscher is a small and playful breed of dog that was originally bred in Germany for hunting small game. They are intelligent, energetic, and affectionate, and make excellent companion dogs.",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFFCCCAC0),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Life Expectancy: 14 - 16 years",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFFCCCAC0),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Male Weight: 3 - 5 kg",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFFCCCAC0),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Female Weight: 3 - 5 kg",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFFCCCAC0),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Hypoallergenic: true",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  color: const Color(0xFF90EE90),
                  child: Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Card(
                              color: const Color(0xFF75C475),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Name: Afghan Hound",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFF75C475),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Description: The Afghan Hound is a large and elegant breed of dog that was originally bred in Afghanistan for hunting small game. They are intelligent, independent, and athletic, and make excellent companion dogs.",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFF75C475),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Life Expectancy: 12 - 14 years",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFF75C475),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Male Weight: 23 - 27 kg",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFF75C475),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Female Weight: 20 - 25 kg",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFF75C475),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Hypoallergenic: false",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  color: const Color(0xFFADD8E6),
                  child: Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Card(
                              color: const Color(0xFF95BDCC),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Name: Akita",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFF95BDCC),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Description: The Akita is a large, muscular dog breed that originated in Japan. They are known for their loyalty and courage.",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFF95BDCC),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Life Expectancy: 10 - 12 years",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFF95BDCC),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Male Weight: 35 - 60 kg",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFF95BDCC),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Female Weight: 35 - 50 kg",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFF95BDCC),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Hypoallergenic: false",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  color: const Color(0xFFE6E6FA),
                  child: Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Card(
                              color: const Color(0xFFD0D0E0),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Name: Alaskan Klee Kai",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFFD0D0E0),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Description: The Alaskan Klee Kai is a small to medium-sized breed of dog that was developed in Alaska in the 1970s. It is an active and intelligent breed that is loyal and friendly. The Alaskan Klee Kai stands between 13-17 inches at the shoulder and has a double-coat that can come in various colors and patterns.",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFFD0D0E0),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Life Expectancy: 12 - 15 years",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFFD0D0E0),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Male Weight: 6 - 7 kg",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFFD0D0E0),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Female Weight: 6 - 7 kg",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFFD0D0E0),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Hypoallergenic: false",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  color: const Color(0xFFF08080),
                  child: Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Card(
                              color: const Color(0xFFD16767),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Name: Alaskan Malamute",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFFD16767),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Description: The Alaskan Malamute is a large and powerful sled dog from Alaska. They are strong and hardworking, yet friendly and loyal. Alaskan Malamutes have a thick, double coat that can be any color. They are active and require plenty of exercise and mental stimulation to stay healthy and happy.",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFFD16767),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Life Expectancy: 12 - 15 years",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFFD16767),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Male Weight: 34 - 39 kg",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFFD16767),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Female Weight: 25 - 34 kg",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFFD16767),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Hypoallergenic: false",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  color: const Color(0xFFFFFFE0),
                  child: Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Card(
                              color: const Color(0xFFCCCAC0),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Name: American Bulldog",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFFCCCAC0),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Description: The American Bulldog is a large and powerful breed of dog that was originally bred in the United States for working on farms. They are intelligent, loyal, and protective, and make excellent guard dogs.",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFFCCCAC0),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Life Expectancy: 12 - 14 years",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFFCCCAC0),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Male Weight: 25 - 50 kg",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFFCCCAC0),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Female Weight: 25 - 45 kg",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFFCCCAC0),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Hypoallergenic: false",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  color: const Color(0xFF90EE90),
                  child: Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Card(
                              color: const Color(0xFF75C475),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Name: American English Coonhound",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFF75C475),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Description: The American English Coonhound is a large and athletic breed of dog that was originally bred in the United States for hunting raccoons. They are intelligent, energetic, and determined, and make excellent hunting dogs.",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFF75C475),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Life Expectancy: 12 - 14 years",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFF75C475),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Male Weight: 20 - 30 kg",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFF75C475),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Female Weight: 20 - 30 kg",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: const Color(0xFF75C475),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  "Hypoallergenic: false",
                                  style: TextStyle(
                                    fontSize: 16.8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
