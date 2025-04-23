import 'package:flutter/material.dart';
import 'states_of_matter_page.dart';
import 'quiz_question_1.dart';
import 'quiz_question_2.dart';
import 'quiz_question_3.dart';
import 'quiz_question_4.dart';
import 'quiz_question_5.dart';
import 'quiz_question_6.dart';
import 'quiz_question_7.dart';

void main() {
  runApp(const MyApp());
}

// Helper class to manage quiz navigation
class QuizNavigator {
  static const int totalQuestions = 7;
  
  static Widget getQuestionByIndex(int index) {
    switch (index) {
      case 1:
        return const IceCreamQuiz();
      case 2:
        return MatchPairGame();
      case 3:
        return const IdentifyProcessScreen();
      case 4:
        return const QuizScreen();
      case 5:
        return WaterVaporQuiz();
      case 6:
        return const MatchingGame();
      case 7:
        return const GasQuiz();
      default:
        return const StatesOfMatterPage();
    }
  }
  
  static void navigateToQuestion(BuildContext context, int index) {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => getQuestionByIndex(index))
    );
  }
  
  static void navigateNext(BuildContext context, int currentIndex) {
    navigateToQuestion(context, currentIndex + 1);
  }
  
  static void navigateBack(BuildContext context, int currentIndex) {
    navigateToQuestion(context, currentIndex - 1);
  }
  
  static void returnToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const StatesOfMatterPage()),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const StatesOfMatterPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
