import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'quiz_question_3.dart'; // Added to navigate to quiz_question_3

class MatchPairGame extends StatefulWidget {
  const MatchPairGame({super.key});

  @override
  _MatchPairGameState createState() => _MatchPairGameState();
}

class _MatchPairGameState extends State<MatchPairGame> {
  String selectedLanguage = "English";
  final String translateApiUrl = "https://api.mymemory.translated.net/get";

  // Items and their correct match
  Map<String, String> correctAnswers = {
    "Rock": "Solid",
    "Milk": "Liquid",
    "Oxygen": "Gas",
  };

  // Translated words storage
  Map<String, String> translations = {
    "Rock": "Rock",
    "Milk": "Milk",
    "Oxygen": "Oxygen",
    "Solid": "Solid",
    "Liquid": "Liquid",
    "Gas": "Gas",
    "Match the Pairs!": "Match the Pairs!",
    "Drag items to their correct category!": "Drag items to their correct category!",
    "Drop items here!": "Drop items here!",
    "Reset 🔄": "Reset 🔄",
    "Check ✅": "Check ✅",
    "Great Job! 🎉": "Great Job! 🎉",
    "Try Again! ❌": "Try Again! ❌",
    "All matches are correct!": "All matches are correct!",
    "Some items are in the wrong place.": "Some items are in the wrong place."
  };

  Map<String, String> userAnswers = {};

  Future<void> translateGameText(String targetLanguageCode) async {
    for (String key in translations.keys) {
      try {
        final response = await http.get(
          Uri.parse("$translateApiUrl?q=${Uri.encodeComponent(key)}&langpair=en|$targetLanguageCode"),
        );

        if (response.statusCode == 200) {
          final decodedResponse = jsonDecode(response.body);
          setState(() {
            translations[key] = decodedResponse["responseData"]["translatedText"];
          });
        } else {
          debugPrint("Translation API Error: ${response.body}");
        }
      } catch (e) {
        debugPrint("Translation Error: $e");
      }
    }
  }

  void resetGame() {
    setState(() {
      userAnswers.clear();
    });
  }

  void checkAnswers() {
    bool correct = userAnswers.length == correctAnswers.length &&
        userAnswers.entries.every((entry) => correctAnswers[entry.key] == entry.value);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(correct ? translations["Great Job! 🎉"]! : translations["Try Again! ❌"]!),
        content: Text(
          correct ? translations["All matches are correct!"]! : translations["Some items are in the wrong place."]!,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(translations["Match the Pairs!"]!),
            DropdownButton<String>(
              value: selectedLanguage,
              icon: const Icon(Icons.language, color: Colors.white),
              dropdownColor: Colors.blue.shade300,
              style: const TextStyle(color: Colors.white),
              underline: Container(height: 0),
              items: [
                {"name": "English", "code": "en"},
                {"name": "Spanish", "code": "es"},
                {"name": "Afrikaans", "code": "af"}
              ].map((lang) {
                return DropdownMenuItem<String>(
                  value: lang["name"],
                  child: Text(
                    lang["name"]!,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (String? newLanguage) {
                if (newLanguage != null) {
                  setState(() {
                    selectedLanguage = newLanguage;
                  });

                  switch (newLanguage) {
                    case "Spanish":
                      translateGameText("es");
                      break;
                    case "Afrikaans":
                      translateGameText("af");
                      break;
                    default:
                      setState(() {
                        translations = {
                          "Rock": "Rock",
                          "Milk": "Milk",
                          "Oxygen": "Oxygen",
                          "Solid": "Solid",
                          "Liquid": "Liquid",
                          "Gas": "Gas",
                          "Match the Pairs!": "Match the Pairs!",
                          "Drag items to their correct category!": "Drag items to their correct category!",
                          "Drop items here!": "Drop items here!",
                          "Reset 🔄": "Reset 🔄",
                          "Check ✅": "Check ✅",
                          "Great Job! 🎉": "Great Job! 🎉",
                          "Try Again! ❌": "Try Again! ❌",
                          "All matches are correct!": "All matches are correct!",
                          "Some items are in the wrong place.": "Some items are in the wrong place."
                        };
                      });
                  }
                }
              },
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade400,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Progress indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // Added vertical padding
                child: Row(
                  children: [
                    const Text(
                      "2/7", // Corrected question number
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: 2/7, // Corrected progress value
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10), // Keep some space
              Text(
                translations["Drag items to their correct category!"]!,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Draggable Images
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  {"name": "Rock", "image": "assets/rock.png"},
                  {"name": "Milk", "image": "assets/milk.png"},
                  {"name": "Oxygen", "image": "assets/oxygen.png"}
                ].map((item) {
                  return Draggable<String>(
                    data: item["name"]!,
                    feedback: Material(
                      child: Image.asset(item["image"]!, width: 80, height: 80),
                    ),
                    childWhenDragging: const SizedBox.shrink(),
                    child: Image.asset(item["image"]!, width: 80, height: 80),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Drop Zones with Labels
              Column(
                children: ["Solid", "Liquid", "Gas"].map((state) {
                  return DragTarget<String>(
                    onAccept: (item) {
                      setState(() {
                        userAnswers[item] = state;
                      });
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        width: 250,
                        height: 100,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blue, width: 2),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              translations[state]!,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            userAnswers.entries.firstWhere(
                                      (entry) => entry.value == state,
                                      orElse: () => const MapEntry("", ""),
                                    ).key.isNotEmpty
                                ? Image.asset(
                                    "assets/${userAnswers.entries.firstWhere((entry) => entry.value == state).key.toLowerCase()}.png",
                                    width: 50,
                                    height: 50,
                                  )
                                : Text(translations["Drop items here!"]!),
                          ],
                        ),
                      );
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: resetGame, child: Text(translations["Reset 🔄"]!)),
                  ElevatedButton(onPressed: checkAnswers, child: Text(translations["Check ✅"]!)),
                ],
              ),

              const SizedBox(height: 20),

              // New Next Button to navigate to quiz_question_3
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const IdentifyProcessScreen()),
                  );
                },
                child: const Text("Next ➡️"),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}