import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:js' as js;
import 'package:flutter_tts/flutter_tts.dart';
import 'quiz_question_4.dart';

class IdentifyProcessScreen extends StatefulWidget {
  const IdentifyProcessScreen({super.key});

  @override
  _IdentifyProcessScreenState createState() => _IdentifyProcessScreenState();
}

class _IdentifyProcessScreenState extends State<IdentifyProcessScreen> {
  late ConfettiController _confettiController;
  final FlutterTts flutterTts = FlutterTts();

  bool showFeedback = false;
  String feedbackMessage = "";
  Color feedbackColor = Colors.transparent;

  String selectedLanguage = "English";
  final String translateApiUrl = "https://api.mymemory.translated.net/get";

  String titleText = "Identify the Process";
  String tryAgainText = "Try Again";
  String nextButtonText = "Next ➡️";
  String answer1 = "Condensation";
  String answer2 = "Evaporation";
  String answer3 = "Sublimation";
  String answer4 = "Melting";
  String correctFeedback = "Correct! This is a melting process.";
  String wrongFeedback = "Wrong! Try again.";

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
    if (!kIsWeb) flutterTts.stop();
    super.dispose();
  }

  Future<void> speak(String text) async {
    if (kIsWeb) {
      js.context.callMethod('speakText', [text, "en-US"]);
    } else {
      await flutterTts.stop();
      await flutterTts.setLanguage("en-US");
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.speak(text);
    }
  }

  Future<void> translateText(String targetLanguageCode) async {
    try {
      Map<String, String> textsToTranslate = {
        "titleText": "Identify the Process",
        "tryAgainText": "Try Again",
        "nextButtonText": "Next ➡️",
        "answer1": "Condensation",
        "answer2": "Evaporation",
        "answer3": "Sublimation",
        "answer4": "Melting",
        "correctFeedback": "Correct! This is a melting process.",
        "wrongFeedback": "Wrong! Try again.",
      };

      for (String key in textsToTranslate.keys) {
        final response = await http.get(
          Uri.parse(
            "$translateApiUrl?q=${Uri.encodeComponent(textsToTranslate[key]!)}&langpair=en|$targetLanguageCode",
          ),
        );
        if (response.statusCode == 200) {
          final translatedText =
              jsonDecode(response.body)["responseData"]["translatedText"];
          setState(() {
            switch (key) {
              case "titleText":
                titleText = translatedText;
                break;
              case "tryAgainText":
                tryAgainText = translatedText;
                break;
              case "nextButtonText":
                nextButtonText = translatedText;
                break;
              case "answer1":
                answer1 = translatedText;
                break;
              case "answer2":
                answer2 = translatedText;
                break;
              case "answer3":
                answer3 = translatedText;
                break;
              case "answer4":
                answer4 = translatedText;
                break;
              case "correctFeedback":
                correctFeedback = translatedText;
                break;
              case "wrongFeedback":
                wrongFeedback = translatedText;
                break;
            }
          });
        }
      }
    } catch (e) {
      debugPrint("Translation Error: $e");
    }
  }

  void checkAnswer(bool isCorrect) {
    setState(() {
      if (isCorrect) {
        _confettiController.play();
        feedbackMessage = correctFeedback;
        feedbackColor = Colors.green.shade100;
        showFeedback = true;
      } else {
        feedbackMessage = wrongFeedback;
        feedbackColor = Colors.red.shade100;
        showFeedback = true;
      }
    });
  }

  void resetQuiz() {
    setState(() {
      showFeedback = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            QuizNavigator.navigateBack(context, 3);
          },
        ),
        title: Text(titleText),
        backgroundColor: Colors.blue,
        actions: [
          DropdownButton<String>(
            value: selectedLanguage,
            dropdownColor: Colors.blue,
            icon: const Icon(Icons.language, color: Colors.white),
            style: const TextStyle(color: Colors.white),
            underline: Container(height: 0),
            items: const [
              DropdownMenuItem(value: 'English', child: Text('English')),
              DropdownMenuItem(value: 'Spanish', child: Text('Spanish')),
              DropdownMenuItem(value: 'Afrikaans', child: Text('Afrikaans')),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedLanguage = value;
                });
                if (value == "Spanish") {
                  translateText("es");
                } else if (value == "Afrikaans") {
                  translateText("af");
                } else {
                  setState(() {
                    titleText = "Identify the Process";
                    tryAgainText = "Try Again";
                    nextButtonText = "Next ➡️";
                    answer1 = "Condensation";
                    answer2 = "Evaporation";
                    answer3 = "Sublimation";
                    answer4 = "Melting";
                    correctFeedback = "Correct! This is a melting process.";
                    wrongFeedback = "Wrong! Try again.";
                  });
                }
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          const Text(
                            "3/7",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: 3 / 7,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.purple,
                              ),
                              minHeight: 10,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      titleText,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Pacifico',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/melting.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        answerButton(
                          label: answer1,
                          originalText: "Condensation",
                          icon: Icons.water_drop,
                          isCorrect: false,
                        ),
                        answerButton(
                          label: answer2,
                          originalText: "Evaporation",
                          icon: Icons.waves,
                          isCorrect: false,
                        ),
                        answerButton(
                          label: answer3,
                          originalText: "Sublimation",
                          icon: Icons.science,
                          isCorrect: false,
                        ),
                        answerButton(
                          label: answer4,
                          originalText: "Melting",
                          icon: Icons.thermostat,
                          isCorrect: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (showFeedback)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: feedbackColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              feedbackMessage.contains("Correct")
                                  ? Icons.check_circle
                                  : Icons.error,
                              color:
                                  feedbackMessage.contains("Correct")
                                      ? Colors.green
                                      : Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              feedbackMessage,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: resetQuiz,
                      icon: const Icon(Icons.refresh),
                      label: Text(tryAgainText),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        QuizNavigator.navigateNext(context, 3);
                      },
                      child: Text(nextButtonText),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget answerButton({
    required String label,
    required String originalText,
    required IconData icon,
    required bool isCorrect,
  }) {
    return GestureDetector(
      onTap: () {
        speak(originalText); // Always speak in English
        checkAnswer(isCorrect);
      },
      child: Container(
        width: 150,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, width: 2),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: isCorrect ? Colors.green : Colors.blue),
            const SizedBox(height: 5),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
