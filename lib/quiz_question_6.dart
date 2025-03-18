import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuizQuestion6 extends StatefulWidget {
  const QuizQuestion6({Key? key}) : super(key: key);

  @override
  _QuizQuestion6State createState() => _QuizQuestion6State();
}

class _QuizQuestion6State extends State<QuizQuestion6> {
  final ConfettiController _confettiController = ConfettiController(
    duration: Duration(seconds: 2),
  );

  // ------------------------------------------------------------------
  // ADDED TRANSLATION VARIABLES AND FUNCTION
  // ------------------------------------------------------------------
  String selectedLanguage = "English";
  final String translateApiUrl = "https://api.mymemory.translated.net/get";

  // Text that will be translated
  String titleText = "Match the Pairs!";
  String instructionText = "Tap on an image and then on the correct answer";
  String checkButtonText = "Check ✅";
  String resetButtonText = "Reset 🔄";
  String correctDialogTitle = "Correct! 🎉";
  String wrongDialogTitle = "Try Again! ❌";
  // Labels for the right side
  String gasLabel = "Gas";
  String solidLabel = "Solid";

  // This function translates each of the strings above.
  Future<void> translateText(String targetLanguageCode) async {
    try {
      // Map each variable name to its English default text
      Map<String, String> textsToTranslate = {
        "titleText": "Match the Pairs!",
        "instructionText": "Tap on an image and then on the correct answer",
        "checkButtonText": "Check ✅",
        "resetButtonText": "Reset 🔄",
        "correctDialogTitle": "Correct! 🎉",
        "wrongDialogTitle": "Try Again! ❌",
        "gasLabel": "Gas",
        "solidLabel": "Solid",
      };

      // For each text, call the translation API and update state
      for (String key in textsToTranslate.keys) {
        final response = await http.get(
          Uri.parse(
            "$translateApiUrl?q=${Uri.encodeComponent(textsToTranslate[key]!)}&langpair=en|$targetLanguageCode",
          ),
        );
        if (response.statusCode == 200) {
          final translatedText =
              jsonDecode(response.body)["responseData"]["translatedText"];
          setState(() {
            switch (key) {
              case "titleText":
                titleText = translatedText;
                break;
              case "instructionText":
                instructionText = translatedText;
                break;
              case "checkButtonText":
                checkButtonText = translatedText;
                break;
              case "resetButtonText":
                resetButtonText = translatedText;
                break;
              case "correctDialogTitle":
                correctDialogTitle = translatedText;
                break;
              case "wrongDialogTitle":
                wrongDialogTitle = translatedText;
                break;
              case "gasLabel":
                gasLabel = translatedText;
                break;
              case "solidLabel":
                solidLabel = translatedText;
                break;
            }
          });
        }
      }
    } catch (e) {
      debugPrint("Translation Error: $e");
    }
  }
  // ------------------------------------------------------------------

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
            title: Text(correct ? correctDialogTitle : wrongDialogTitle),
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
      // ------------------------------------------------------------------
      // ADDED DROPDOWN IN APPBAR ACTIONS
      // ------------------------------------------------------------------
      appBar: AppBar(
        title: Text(titleText),
        backgroundColor: Colors.blue.shade400,
        actions: [
          DropdownButton<String>(
            value: selectedLanguage,
            dropdownColor: Colors.blue.shade300,
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
                  // Reset to English defaults
                  setState(() {
                    titleText = "Match the Pairs!";
                    instructionText =
                        "Tap on an image and then on the correct answer";
                    checkButtonText = "Check ✅";
                    resetButtonText = "Reset 🔄";
                    correctDialogTitle = "Correct! 🎉";
                    wrongDialogTitle = "Try Again! ❌";
                    gasLabel = "Gas";
                    solidLabel = "Solid";
                  });
                }
              }
            },
          ),
        ],
      ),
      // ------------------------------------------------------------------
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
                  instructionText,
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
                              gasLabel,
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
                              solidLabel,
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
                        checkButtonText,
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
                        resetButtonText,
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
