import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

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

  void checkAnswer(String answer) {
    if (answer.toLowerCase() == 'evaporation') {
      setState(() {
        feedbackText = "✅ Correct! That's right!";
        feedbackColor = Colors.green.shade100;
        buttonColor = null;
      });
      _confettiController.play();
    } else {
      setState(() {
        feedbackText = "❌ Try again!";
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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Water Cycle Quiz"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Identify the Process',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/evaporation.jpg',
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
                    answerButton('Evaporation', 'evaporation'),
                    answerButton('Sublimation', 'sublimation'),
                    answerButton('Condensation', 'condensation'),
                    answerButton('Freezing', 'freezing'),
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
                        fontWeight: FontWeight.bold, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: resetQuiz,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Try Again 🔄"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      // Confetti widget overlaid on top
      floatingActionButton: ConfettiWidget(
        confettiController: _confettiController,
        blastDirection: -pi / 2,
        emissionFrequency: 0.05,
        numberOfParticles: 20,
        gravity: 0.2,
      ),
    );
  }

  Widget answerButton(String text, String answer) {
    return ElevatedButton(
      onPressed: () => checkAnswer(answer),
      child: Text(text, style: const TextStyle(fontSize: 16)),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        backgroundColor: buttonColor != null && answer.toLowerCase() != 'evaporation'
            ? buttonColor
            : Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}