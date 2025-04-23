import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:lottie/lottie.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'main.dart';

class CondensationQuiz extends StatefulWidget {
  const CondensationQuiz({super.key});

  @override
  _CondensationQuizState createState() => _CondensationQuizState();
}

class _CondensationQuizState extends State<CondensationQuiz> {
  String? selectedAnswer;
  bool isCorrect = false;
  bool isAnswered = false;
  late ConfettiController _confettiController;
  String selectedLanguage = "English";
  String questionText = "When you see water droplets form on the outside of a cold glass, what process is happening?";
  String hintMessage = "Hint: Think about how water vapor in the air changes when it touches a cold surface! 💧";
  String nextButtonText = "Finish Quiz";
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
      
      final nextButtonResponse = await http.get(
        Uri.parse("$translateApiUrl?q=${Uri.encodeComponent(nextButtonText)}&langpair=en|$targetLanguageCode"),
      );

      if (response.statusCode == 200 && hintResponse.statusCode == 200 && nextButtonResponse.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        final decodedHintResponse = jsonDecode(hintResponse.body);
        final decodedNextButtonResponse = jsonDecode(nextButtonResponse.body);
        setState(() {
          questionText = decodedResponse["responseData"]["translatedText"];
          hintMessage = decodedHintResponse["responseData"]["translatedText"];
          nextButtonText = decodedNextButtonResponse["responseData"]["translatedText"];
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
      if (answer == 'Condensation') {
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

  void finishQuiz() {
    QuizNavigator.returnToHome(context);
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
            QuizNavigator.navigateBack(context, 8);
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
                        questionText = "When you see water droplets form on the outside of a cold glass, what process is happening?";
                        hintMessage = "Hint: Think about how water vapor in the air changes when it touches a cold surface! 💧";
                        nextButtonText = "Finish Quiz";
                      });
                  }
                }
              },
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade400,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Progress indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  const Text(
                    "8/8",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: 1.0, // Last question, fully complete
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
            
            // Cold Glass Image
            Container(
              height: 450,
              width: 450,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  "assets/cold_glass.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Question Card
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
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
                  const SizedBox(height: 10),

                  // Answer Buttons
                  Column(
                    children: ['Melting', 'Condensation', 'Freezing', 'Evaporation'].map((answer) {
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
                                "✅ Correct! When warm, moist air touches the cold glass surface, the water vapor in the air condenses into liquid water droplets.",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: finishQuiz,
                                icon: const Icon(Icons.check_circle),
                                label: Text(nextButtonText),
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
                                "❌ Not quite! Try again to identify the correct process.",
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
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.green, Colors.blue, Colors.purple, Colors.orange],
            ),
          ],
        ),
      ),
    );
  }
} 