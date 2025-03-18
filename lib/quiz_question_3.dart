import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'quiz_question_4.dart'; // Import quiz_question_4 for navigation

class IdentifyProcessScreen extends StatefulWidget {
  const IdentifyProcessScreen({super.key});

  @override
  _IdentifyProcessScreenState createState() => _IdentifyProcessScreenState();
}

class _IdentifyProcessScreenState extends State<IdentifyProcessScreen> {
  late ConfettiController _confettiController;
  bool showFeedback = false;
  String feedbackMessage = "";
  Color feedbackColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void checkAnswer(bool isCorrect) {
    setState(() {
      if (isCorrect) {
        _confettiController.play();
        feedbackMessage = "Correct! This is a melting process.";
        feedbackColor = Colors.green.shade100;
        showFeedback = true;
      } else {
        feedbackMessage = "Wrong! Try again.";
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
        title: const Text("Identify the Process"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Identify the Process",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pacifico',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  "https://creatie.ai/ai/api/search-image?query=realistic illustration of butter melting process",
                  width: 300,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  answerButton("Condensation", Icons.water_drop, false),
                  answerButton("Evaporation", Icons.waves, false),
                  answerButton("Sublimation", Icons.science, false),
                  answerButton("Melting", Icons.thermostat, true),
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
                        color: feedbackMessage.contains("Correct")
                            ? Colors.green
                            : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        feedbackMessage,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: resetQuiz,
                icon: const Icon(Icons.refresh),
                label: const Text("Try Again"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),
              // Next button to navigate to quiz_question_4
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QuizScreen()),
                  );
                },
                child: const Text("Next ➡️"),
              ),
              const SizedBox(height: 20),
              ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: pi / 2,
                numberOfParticles: 20,
                gravity: 0.1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget answerButton(String text, IconData icon, bool isCorrect) {
    return GestureDetector(
      onTap: () => checkAnswer(isCorrect),
      child: Container(
        width: 150,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: isCorrect ? Colors.green : Colors.blue),
            const SizedBox(height: 5),
            Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}