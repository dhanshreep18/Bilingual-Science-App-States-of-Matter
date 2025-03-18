import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  String feedbackText = '';
  Color feedbackColor = Colors.transparent;
  Color? buttonColor;
  late ConfettiController _confettiController;

  // Language translation variables
  String selectedLanguage = "English";
  final String translateApiUrl = "https://api.mymemory.translated.net/get";

  // UI texts that can be translated
  String titleText = "Water Cycle Challenge!";
  String subtitleText = "Which process is depicted?";
  String questionText = "Identify the process";
  String tryAgainText = "Try Again 🔄";
  String nextQuestionText = "Next Question";
  String answer1 = "Evaporation";
  String answer2 = "Sublimation";
  String answer3 = "Condensation";
  String answer4 = "Freezing";
  String correctFeedback = "✅ Correct! You're on fire!";
  String wrongFeedback = "❌ Oops! Try again!";

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> translateText(String targetLanguageCode) async {
    try {
      Map<String, String> textsToTranslate = {
        "titleText": "Water Cycle Challenge!",
        "subtitleText": "Which process is depicted?",
        "questionText": "Identify the process",
        "tryAgainText": "Try Again 🔄",
        "nextQuestionText": "Next Question",
        "answer1": "Evaporation",
        "answer2": "Sublimation",
        "answer3": "Condensation",
        "answer4": "Freezing",
        "correctFeedback": "✅ Correct! You're on fire!",
        "wrongFeedback": "❌ Oops! Try again!",
      };

      for (String key in textsToTranslate.keys) {
        final response = await http.get(
          Uri.parse("$translateApiUrl?q=${Uri.encodeComponent(textsToTranslate[key]!)}&langpair=en|$targetLanguageCode"),
        );
        if (response.statusCode == 200) {
          final translatedText = jsonDecode(response.body)["responseData"]["translatedText"];
          setState(() {
            switch (key) {
              case "titleText":
                titleText = translatedText;
                break;
              case "subtitleText":
                subtitleText = translatedText;
                break;
              case "questionText":
                questionText = translatedText;
                break;
              case "tryAgainText":
                tryAgainText = translatedText;
                break;
              case "nextQuestionText":
                nextQuestionText = translatedText;
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

  void checkAnswer(String answer) {
    if (answer.toLowerCase() == 'evaporation') {
      setState(() {
        feedbackText = correctFeedback;
        feedbackColor = Colors.green.shade100;
        buttonColor = null;
      });
      _confettiController.play();
    } else {
      setState(() {
        feedbackText = wrongFeedback;
        feedbackColor = Colors.red.shade100;
        buttonColor = Colors.red;
      });
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          buttonColor = null;
        });
      });
    }
  }

  void resetQuiz() {
    setState(() {
      feedbackText = '';
      feedbackColor = Colors.transparent;
      buttonColor = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fun gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        titleText,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pacifico',
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        subtitleText,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/evaporation.jpg',
                          width: 300,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        questionText,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children: [
                          answerButton(answer1, 'evaporation'),
                          answerButton(answer2, 'sublimation'),
                          answerButton(answer3, 'condensation'),
                          answerButton(answer4, 'freezing'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: feedbackColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          feedbackText,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black),
                          textAlign: TextAlign.center,
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
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Navigation for next question can be added here if available.
                        },
                        child: Text(nextQuestionText),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              // Fun confetti effect at the top center
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirection: -pi / 2,
                  emissionFrequency: 0.05,
                  numberOfParticles: 30,
                  gravity: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text("Water Cycle Quiz"),
        backgroundColor: Colors.blue, // Changed from transparent to blue
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
                    titleText = "Water Cycle Challenge!";
                    subtitleText = "Which process is depicted?";
                    questionText = "Identify the process";
                    tryAgainText = "Try Again 🔄";
                    nextQuestionText = "Next Question";
                    answer1 = "Evaporation";
                    answer2 = "Sublimation";
                    answer3 = "Condensation";
                    answer4 = "Freezing";
                    correctFeedback = "✅ Correct! You're on fire!";
                    wrongFeedback = "❌ Oops! Try again!";
                  });
                }
              }
            },
          )
        ],
      ),
    );
  }

  Widget answerButton(String text, String answer) {
    return ElevatedButton(
      onPressed: () => checkAnswer(answer),
      child: Text(text, style: const TextStyle(fontSize: 16)),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        backgroundColor: buttonColor != null && answer.toLowerCase() != 'evaporation'
            ? buttonColor
            : Colors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}