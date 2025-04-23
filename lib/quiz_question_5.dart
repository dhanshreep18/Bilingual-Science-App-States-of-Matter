import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:lottie/lottie.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Make sure this import points to your quiz_question_6.dart
import 'quiz_question_6.dart';
import 'quiz_question_4.dart';
import 'main.dart';

class WaterVaporQuiz extends StatefulWidget {
  WaterVaporQuiz({Key? key}) : super(key: key);

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
    "Next": "Next Question",
  };

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
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
  
  void goToNextPage() {
    QuizNavigator.navigateNext(context, 5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            QuizNavigator.navigateBack(context, 5);
          },
        ),
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
              items: [
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
                          "hint": "Hint: Think about the steam rising from hot tea! 🍵",
                          "Solid": "Solid",
                          "Liquid": "Liquid",
                          "Gas": "Gas",
                          "Correct": "✅ Correct! Water vapor is a **gas**! ☁️",
                          "Wrong": "❌ Oops! Water vapor is a gas. Try again!",
                          "Try Again": "Try Again 🔄",
                          "Next": "Next Question",
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
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Progress indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    const Text(
                      "5/8",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: 5/8, // Fifth question out of 8
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 10),
              
              // Animation
              SizedBox(
                height: 300,
                child: Lottie.asset(
                  "assets/vapor.json",
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
                      children: [
                        translations["Solid"]!,
                        translations["Liquid"]!,
                        translations["Gas"]!,
                      ].map((answer) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedAnswer == answer
                                  ? (isCorrect ? Colors.green : Colors.red)
                                  : Colors.blue.shade300,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: isAnswered ? null : () => checkAnswer(answer),
                            child: Text(
                              answer,
                              style: const TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    // Feedback Message
                    if (isAnswered)
                      isCorrect
                          ? Column(
                              children: [
                                Text(
                                  translations["Correct"]!,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton.icon(
                                  onPressed: goToNextPage,
                                  icon: const Icon(Icons.navigate_next),
                                  label: Text(translations["Next"]!),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    minimumSize: const Size(double.infinity, 48),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Text(
                                  translations["Wrong"]!,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
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
                                  child: Text(translations["Try Again"]!, style: const TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                  ],
                ),
              ),
              ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [Colors.green, Colors.blue, Colors.orange, Colors.pink],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
