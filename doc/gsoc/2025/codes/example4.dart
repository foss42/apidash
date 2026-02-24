// ignore_for_file: use_key_in_widget_constructors, use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SDUIWidget(), // Removed extra Scaffold
    );
  }
}

class SDUIWidget extends StatelessWidget {
  const SDUIWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF303030),
      body: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            "Different Dog Breeds",
            style: TextStyle(
              color: Color(0xFFFFFF00), // Fixed yellow color
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(10),
              crossAxisCount: 3,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 1.0,
              children: [

                /// ================= CARD 1 =================
                Card(
                  color: const Color(0xFFFFFFE0),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: const [
                          BreedTile(title: "Name: Affenpinscher", bold: true),
                          BreedTile(
                            title:
                                "Description: The Affenpinscher is a small and playful breed of dog that was originally bred in Germany for hunting small game. They are intelligent, energetic, and affectionate, and make excellent companion dogs.",
                          ),
                          BreedTile(title: "Life Expectancy: 14 - 16 years", bold: true),
                          BreedTile(title: "Male Weight: 3 - 5 kg", bold: true),
                          BreedTile(title: "Female Weight: 3 - 5 kg", bold: true),
                          BreedTile(title: "Hypoallergenic: true", bold: true),
                        ],
                      ),
                    ),
                  ),
                ),

                /// ================= CARD 2 =================
                Card(
                  color: const Color(0xFF90EE90),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: const [
                          BreedTile(title: "Name: Afghan Hound", bold: true),
                          BreedTile(
                            title:
                                "Description: The Afghan Hound is a large and elegant breed of dog that was originally bred in Afghanistan for hunting small game. They are intelligent, independent, and athletic, and make excellent companion dogs.",
                          ),
                          BreedTile(title: "Life Expectancy: 12 - 14 years", bold: true),
                          BreedTile(title: "Male Weight: 23 - 27 kg", bold: true),
                          BreedTile(title: "Female Weight: 20 - 25 kg", bold: true),
                          BreedTile(title: "Hypoallergenic: false", bold: true),
                        ],
                      ),
                    ),
                  ),
                ),

                /// ================= CARD 3 =================
                Card(
                  color: const Color(0xFFADD8E6),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: const [
                          BreedTile(title: "Name: Akita", bold: true),
                          BreedTile(
                            title:
                                "Description: The Akita is a large, muscular dog breed that originated in Japan. They are known for their loyalty and courage.",
                          ),
                          BreedTile(title: "Life Expectancy: 10 - 12 years", bold: true),
                          BreedTile(title: "Male Weight: 35 - 60 kg", bold: true),
                          BreedTile(title: "Female Weight: 35 - 50 kg", bold: true),
                          BreedTile(title: "Hypoallergenic: false", bold: true),
                        ],
                      ),
                    ),
                  ),
                ),

                /// ================= CARD 4 =================
                Card(
                  color: const Color(0xFFE6E6FA),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: const [
                          BreedTile(title: "Name: Alaskan Klee Kai", bold: true),
                          BreedTile(
                            title:
                                "Description: The Alaskan Klee Kai is a small to medium-sized breed developed in Alaska in the 1970s. It is active, intelligent, loyal and friendly.",
                          ),
                          BreedTile(title: "Life Expectancy: 12 - 15 years", bold: true),
                          BreedTile(title: "Male Weight: 6 - 7 kg", bold: true),
                          BreedTile(title: "Female Weight: 6 - 7 kg", bold: true),
                          BreedTile(title: "Hypoallergenic: false", bold: true),
                        ],
                      ),
                    ),
                  ),
                ),

                /// ================= CARD 5 =================
                Card(
                  color: const Color(0xFFF08080),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: const [
                          BreedTile(title: "Name: Alaskan Malamute", bold: true),
                          BreedTile(
                            title:
                                "Description: The Alaskan Malamute is a large and powerful sled dog from Alaska. They are strong, hardworking, friendly and loyal.",
                          ),
                          BreedTile(title: "Life Expectancy: 12 - 15 years", bold: true),
                          BreedTile(title: "Male Weight: 34 - 39 kg", bold: true),
                          BreedTile(title: "Female Weight: 25 - 34 kg", bold: true),
                          BreedTile(title: "Hypoallergenic: false", bold: true),
                        ],
                      ),
                    ),
                  ),
                ),

                /// ================= CARD 6 =================
                Card(
                  color: const Color(0xFFFFFFE0),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: const [
                          BreedTile(title: "Name: American Bulldog", bold: true),
                          BreedTile(
                            title:
                                "Description: The American Bulldog is a large and powerful breed originally bred in the United States for farm work.",
                          ),
                          BreedTile(title: "Life Expectancy: 12 - 14 years", bold: true),
                          BreedTile(title: "Male Weight: 25 - 50 kg", bold: true),
                          BreedTile(title: "Female Weight: 25 - 45 kg", bold: true),
                          BreedTile(title: "Hypoallergenic: false", bold: true),
                        ],
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

class BreedTile extends StatelessWidget {
  final String title;
  final bool bold;

  const BreedTile({required this.title, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFCCCAC0),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16.8,
            fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
            color: const Color(0xFFFFFFFF),
          ),
        ),
      ),
    );
  }
}