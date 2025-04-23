import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';

class IceCreamQuiz extends StatefulWidget {
  const IceCreamQuiz({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _IceCreamQuizState createState() => _IceCreamQuizState();
}

class _IceCreamQuizState extends State<IceCreamQuiz> {
  String? selectedAnswer;
  bool isCorrect = false;
  bool isAnswered = false;
  late ConfettiController _confettiController;
  String selectedLanguage = "English";
  String questionText = "What state of matter is ice cream? 🍦";
  String hintMessage = "Hint: Think about how ice cream melts when left outside! ☀️";
  String nextButtonText = "Next Question";
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
      if (answer == 'Solid') {
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
    QuizNavigator.navigateNext(context, 1);
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
            QuizNavigator.returnToHome(context);
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
                        questionText = "What state of matter is ice cream? 🍦";
                        hintMessage = "Hint: Think about how ice cream melts when left outside! ☀️";
                        nextButtonText = "Next Question";
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
                    "1/7",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: 1/7, // First question out of 7
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
            
            // Cute Lottie Ice Cream Animation
            SizedBox(
              height: 180,
              child: Lottie.asset(
                "assets/ice_cream.json", // Make sure this file is inside assets/
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
                boxShadow: [
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
                    questionText,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

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
                                "✅ Correct! Ice cream is a **solid** when frozen! 🧊",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: goToNextPage,
                                icon: const Icon(Icons.navigate_next),
                                label: Text(nextButtonText),
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
                              const Text(
                                "❌ Oops! Ice cream starts as a solid when frozen. Try again!",
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