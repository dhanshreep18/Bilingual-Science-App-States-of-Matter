import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class QuizQuestion6 extends StatefulWidget {
  const QuizQuestion6({Key? key}) : super(key: key);

  @override
  _QuizQuestion6State createState() => _QuizQuestion6State();
}

class _QuizQuestion6State extends State<QuizQuestion6> {
  final ConfettiController _confettiController = ConfettiController(
    duration: Duration(seconds: 2),
  );

  Map<String, String> correctAnswers = {
    "WaterVapor": "Gas",
    "IceCube": "Solid",
  };

  Map<String, String> userConnections = {};
  String? selectedLeft;
  bool isCorrect = false;

  final GlobalKey waterVaporKey = GlobalKey();
  final GlobalKey iceCubeKey = GlobalKey();
  final GlobalKey gasKey = GlobalKey();
  final GlobalKey solidKey = GlobalKey();

  void resetGame() {
    setState(() {
      userConnections.clear();
      selectedLeft = null;
      isCorrect = false;
    });
  }

  void checkAnswers() {
    bool correct =
        userConnections.length == correctAnswers.length &&
        userConnections.entries.every(
          (entry) => correctAnswers[entry.key] == entry.value,
        );

    setState(() {
      isCorrect = correct;
      if (correct) {
        _confettiController.play();
      }
    });

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(correct ? "Correct! 🎉" : "Try Again! ❌"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  void selectLeft(String item) {
    setState(() {
      selectedLeft = item;
    });
  }

  void selectRight(String answer) {
    if (selectedLeft != null) {
      setState(() {
        userConnections[selectedLeft!] = answer;
        selectedLeft = null;
      });
    }
  }

  Offset getWidgetPosition(GlobalKey key) {
    RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
    return box?.localToGlobal(
          Offset(box.size.width / 2, box.size.height / 2),
        ) ??
        Offset.zero;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text("Match the Pairs!"),
        backgroundColor: Colors.blue.shade400,
      ),
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return CustomPaint(
                size: Size.infinite,
                painter: LinePainter(
                  userConnections,
                  getWidgetPosition(waterVaporKey),
                  getWidgetPosition(iceCubeKey),
                  getWidgetPosition(gasKey),
                  getWidgetPosition(solidKey),
                ),
              );
            },
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Tap on an image and then on the correct answer",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () => selectLeft("WaterVapor"),
                          child: Container(
                            key: waterVaporKey,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    selectedLeft == "WaterVapor"
                                        ? Colors.blueAccent
                                        : Colors.transparent,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.asset(
                              'assets/watervapor.png',
                              width: 100,
                              height: 100,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        GestureDetector(
                          onTap: () => selectLeft("IceCube"),
                          child: Container(
                            key: iceCubeKey,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    selectedLeft == "IceCube"
                                        ? Colors.blueAccent
                                        : Colors.transparent,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.asset(
                              'assets/icecube.jpeg',
                              width: 100,
                              height: 100,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 100),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () => selectRight("Gas"),
                          child: Container(
                            key: gasKey,
                            padding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    userConnections.values.contains("Gas")
                                        ? Colors.green
                                        : Colors.grey,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "Gas",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        GestureDetector(
                          onTap: () => selectRight("Solid"),
                          child: Container(
                            key: solidKey,
                            padding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    userConnections.values.contains("Solid")
                                        ? Colors.green
                                        : Colors.grey,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "Solid",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: checkAnswers,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        "Check ✅",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: resetGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        "Reset 🔄",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
                ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final Map<String, String> connections;
  final Offset waterVaporPos, iceCubePos, gasPos, solidPos;

  LinePainter(
    this.connections,
    this.waterVaporPos,
    this.iceCubePos,
    this.gasPos,
    this.solidPos,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.blue
          ..strokeWidth = 3.0
          ..style = PaintingStyle.stroke;

    final positions = {
      "WaterVapor": waterVaporPos,
      "IceCube": iceCubePos,
      "Gas": gasPos,
      "Solid": solidPos,
    };

    for (var entry in connections.entries) {
      final start = positions[entry.key]!;
      final end = positions[entry.value]!;
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
