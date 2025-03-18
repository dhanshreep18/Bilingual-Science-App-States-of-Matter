import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:lottie/lottie.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WaterVaporQuiz extends StatefulWidget {
  const WaterVaporQuiz({super.key});

  @override
  _WaterVaporQuizState createState() => _WaterVaporQuizState();
}

class _WaterVaporQuizState extends State<WaterVaporQuiz> {
  String? selectedAnswer;
  bool isCorrect = false;
  bool isAnswered = false;
  late ConfettiController _confettiController;
  String selectedLanguage = "English";
  final String translateApiUrl = "https://api.mymemory.translated.net/get";

  Map<String, String> translations = {
    "question": "What state of matter is water vapor? ☁️",
    "hint": "Hint: Think about the steam rising from hot tea! 🍵",
    "Solid": "Solid",
    "Liquid": "Liquid",
    "Gas": "Gas",
    "Correct": "✅ Correct! Water vapor is a **gas**! ☁️",
    "Wrong": "❌ Oops! Water vapor is a gas. Try again!",
    "Try Again": "Try Again 🔄",
  };

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> translateText(String targetLanguageCode) async {
    for (String key in translations.keys) {
      try {
        final response = await http.get(
          Uri.parse(
            "$translateApiUrl?q=${Uri.encodeComponent(translations[key]!)}&langpair=en|$targetLanguageCode",
          ),
        );

        if (response.statusCode == 200) {
          final decodedResponse = jsonDecode(response.body);
          setState(() {
            translations[key] =
                decodedResponse["responseData"]["translatedText"];
          });
        } else {
          debugPrint("Translation API Error: ${response.body}");
        }
      } catch (e) {
        debugPrint("Translation Error: $e");
      }
    }
  }

  void checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isAnswered = true;
      if (answer == translations["Gas"]) {
        isCorrect = true;
        _confettiController.play();
      } else {
        isCorrect = false;
      }
    });
  }

  void resetQuiz() {
    setState(() {
      selectedAnswer = null;
      isAnswered = false;
      isCorrect = false;
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Fun Science Quiz! ☁️"),
            DropdownButton<String>(
              value: selectedLanguage,
              icon: const Icon(Icons.language, color: Colors.white),
              dropdownColor: Colors.blue.shade300,
              style: const TextStyle(color: Colors.white),
              underline: Container(height: 0),
              items:
                  [
                    {"name": "English", "code": "en"},
                    {"name": "Spanish", "code": "es"},
                    {"name": "Afrikaans", "code": "af"},
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
                      translateText("es");
                      break;
                    case "Afrikaans":
                      translateText("af");
                      break;
                    default:
                      setState(() {
                        translations = {
                          "question": "What state of matter is water vapor? ☁️",
                          "hint":
                              "Hint: Think about the steam rising from hot tea! 🍵",
                          "Solid": "Solid",
                          "Liquid": "Liquid",
                          "Gas": "Gas",
                          "Correct": "✅ Correct! Water vapor is a **gas**! ☁️",
                          "Wrong": "❌ Oops! Water vapor is a gas. Try again!",
                          "Try Again": "Try Again 🔄",
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animation
            SizedBox(
              height: 180,
              child: Lottie.asset(
                "assets/vapor.json", // Ensure this image exists in assets
                repeat: true,
                fit: BoxFit.contain,
              ),
            ),

            // Question Card
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    translations["question"]!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  // Answer Buttons
                  Column(
                    children:
                        [
                          translations["Solid"]!,
                          translations["Liquid"]!,
                          translations["Gas"]!,
                        ].map((answer) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    selectedAnswer == answer
                                        ? (isCorrect
                                            ? Colors.green
                                            : Colors.red)
                                        : Colors.blue.shade300,
                                minimumSize: const Size(200, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed:
                                  isAnswered ? null : () => checkAnswer(answer),
                              child: Text(
                                answer,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // Feedback Message
                  if (isAnswered)
                    Column(
                      children: [
                        Text(
                          isCorrect
                              ? translations["Correct"]!
                              : translations["Wrong"]!,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isCorrect ? Colors.green : Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),

                        // Show hint only when the answer is incorrect
                        if (!isCorrect)
                          Column(
                            children: [
                              Text(
                                translations["hint"]!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: resetQuiz,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                ),
                                child: Text(
                                  translations["Try Again"]!,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),

                        const SizedBox(height: 20),

                        // Show Next button only if the answer is correct
                        if (isCorrect)
                          ElevatedButton(
                            onPressed: () {
                              // Do nothing for now
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              "Next ➡️",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
            if (isCorrect)
              ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: [Colors.green, Colors.blue, Colors.purple],
              ),
            const SizedBox(height: 20),

            // Another "Next ➡️" button that does nothing
            ElevatedButton(
              onPressed: () {
                // Do nothing for now
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
              ),
              child: const Text(
                "Next ➡️",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
