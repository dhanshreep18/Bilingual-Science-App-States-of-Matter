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
        feedbackText = "✅ Correct! You're on fire!";
        feedbackColor = Colors.green.shade100;
        buttonColor = null;
      });
      _confettiController.play();
    } else {
      setState(() {
        feedbackText = "❌ Oops! Try again!";
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
                      const Text(
                        'Water Cycle Challenge!',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pacifico',
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
                      const Text(
                        'Which process is depicted?',
                        style: TextStyle(
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
                        label: const Text("Try Again 🔄"),
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
        backgroundColor: Colors.transparent,
        elevation: 0,
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