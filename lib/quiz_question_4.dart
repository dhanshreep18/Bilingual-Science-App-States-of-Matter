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
  Color feedbackColor = Colors.black;
  Color? buttonColor;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void checkAnswer(String answer) {
    if (answer.toLowerCase() == 'evaporation') {
      setState(() {
        feedbackText = 'Correct! That\'s right!';
        feedbackColor = Colors.green;
      });
      _confettiController.play();
    } else {
      setState(() {
        feedbackText = 'Try again!';
        feedbackColor = Colors.red;
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
      feedbackColor = Colors.black;
      buttonColor = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Water Cycle Quiz"),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Identify the process',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 300,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset('assets/evaporation.jpg', fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 3,
                    children: [
                      buildAnswerButton('Evaporation', 'evaporation'),
                      buildAnswerButton('Sublimation', 'sublimation'),
                      buildAnswerButton('Condensation', 'condensation'),
                      buildAnswerButton('Freezing', 'freezing'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    feedbackText,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: feedbackColor),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: resetQuiz,
                    child: const Text('Next Question'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: -pi / 2,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAnswerButton(String text, String answer) {
    return ElevatedButton(
      onPressed: () => checkAnswer(answer),
      child: Text(text, style: const TextStyle(fontSize: 16)),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10),
        backgroundColor: buttonColor != null && answer.toLowerCase() != 'evaporation' ? buttonColor : Colors.blue,
      ),
    );
  }
}