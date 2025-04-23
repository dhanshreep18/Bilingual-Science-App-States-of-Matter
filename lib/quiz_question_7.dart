import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:lottie/lottie.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'main.dart';

class GasQuiz extends StatefulWidget {
  const GasQuiz({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GasQuizState createState() => _GasQuizState();
}

class _GasQuizState extends State<GasQuiz> {
  String? selectedAnswer;
  bool isCorrect = false;
  bool isAnswered = false;
  late ConfettiController _confettiController;
  String selectedLanguage = "English";
  String questionText = "Which state of matter expands to fill its container?";
  String hintMessage = "Hint: Think about how air or steam moves and fills space! 💨";
  final String translateApiUrl = "https://api.mymemory.translated.net/get";

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  Future<void> translateText(String targetLanguageCode) async {
    try {
      final response = await http.get(
        Uri.parse("$translateApiUrl?q=${Uri.encodeComponent(questionText)}&langpair=en|$targetLanguageCode"),
      );

      final hintResponse = await http.get(
        Uri.parse("$translateApiUrl?q=${Uri.encodeComponent(hintMessage)}&langpair=en|$targetLanguageCode"),
      );

      if (response.statusCode == 200 && hintResponse.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        final decodedHintResponse = jsonDecode(hintResponse.body);
        setState(() {
          questionText = decodedResponse["responseData"]["translatedText"];
          hintMessage = decodedHintResponse["responseData"]["translatedText"];
        });
      } else {
        debugPrint("Translation API Error: ${response.body}");
      }
    } catch (e) {
      debugPrint("Translation Error: $e");
    }
  }

  void checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      isAnswered = true;
      if (answer == 'Gas') {
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            QuizNavigator.navigateBack(context, 7);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("States of Matter Quiz"),
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
                      translateText("es");
                      break;
                    case "Afrikaans":
                      translateText("af");
                      break;
                    default:
                      setState(() {
                        questionText = "Which state of matter expands to fill its container?";
                        hintMessage = "Hint: Think about how air or steam moves and fills space! 💨";
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
                      "7/8",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: 7/8, // Seventh question out of 8
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
              
              // Gas Animation
              SizedBox(
                height: 450,
                width: 450,
                child: Lottie.asset(
                  "assets/gas.json",
                  repeat: true,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 20),

              // Question Card
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      questionText,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // Answer Buttons
                    Column(
                      children: ['Solid', 'Liquid', 'Gas'].map((answer) {
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
                                const Text(
                                  "✅ Correct! Gases expand to fill their containers! 🎈",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    QuizNavigator.navigateNext(context, 7);
                                  },
                                  icon: const Icon(Icons.check_circle),
                                  label: const Text("Next Question"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
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
                                const Text(
                                  "❌ Not quite! Try again to find the correct state of matter.",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  hintMessage,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: resetQuiz,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                  ),
                                  child: const Text("Try Again 🔄", style: TextStyle(color: Colors.white)),
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
                  colors: const [Colors.green, Colors.blue, Colors.purple, Colors.orange],
                ),
            ],
          ),
        ),
      ),
    );
  }
} 