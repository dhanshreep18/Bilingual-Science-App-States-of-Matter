import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'package:flutter_tts/flutter_tts.dart';

class MatchingGame extends StatefulWidget {
  const MatchingGame({super.key});

  @override
  _MatchingGameState createState() => _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {
  final GlobalKey waterVaporKey = GlobalKey();
  final GlobalKey iceCubeKey = GlobalKey();
  final GlobalKey gasKey = GlobalKey();
  final GlobalKey solidKey = GlobalKey();

  String? selectedLeft;
  String? selectedRight;
  String gasLabel = "Gas";
  String solidLabel = "Solid";
  
  Map<String, String> userConnections = {};
  late ConfettiController _confettiController;
  final FlutterTts flutterTts = FlutterTts();

  String selectedLanguage = "English";
  String titleText = "Match the Pairs!";
  String instructionText = "Tap on an image and then on the correct answer";
  String checkButtonText = "Check ✅";
  String resetButtonText = "Reset 🔄";
  String correctDialogTitle = "Correct! 🎉";
  String wrongDialogTitle = "Try Again! ❌";
  String nextButtonText = "Next Question";
  final String translateApiUrl = "https://api.mymemory.translated.net/get";

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    
    // Add a post-frame callback to ensure the UI is built before accessing positions
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        // Just trigger a rebuild to ensure positions are correct
      });
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  Future<void> translateText(String targetLanguageCode) async {
    try {
      final responseTitleText = await http.get(
        Uri.parse("$translateApiUrl?q=${Uri.encodeComponent(titleText)}&langpair=en|$targetLanguageCode"),
      );
      final responseInstructionText = await http.get(
        Uri.parse("$translateApiUrl?q=${Uri.encodeComponent(instructionText)}&langpair=en|$targetLanguageCode"),
      );
      final responseCheckButtonText = await http.get(
        Uri.parse("$translateApiUrl?q=${Uri.encodeComponent(checkButtonText)}&langpair=en|$targetLanguageCode"),
      );
      final responseResetButtonText = await http.get(
        Uri.parse("$translateApiUrl?q=${Uri.encodeComponent(resetButtonText)}&langpair=en|$targetLanguageCode"),
      );
      final responseCorrectDialogTitle = await http.get(
        Uri.parse("$translateApiUrl?q=${Uri.encodeComponent(correctDialogTitle)}&langpair=en|$targetLanguageCode"),
      );
      final responseWrongDialogTitle = await http.get(
        Uri.parse("$translateApiUrl?q=${Uri.encodeComponent(wrongDialogTitle)}&langpair=en|$targetLanguageCode"),
      );
      final responseGasLabel = await http.get(
        Uri.parse("$translateApiUrl?q=${Uri.encodeComponent("Gas")}&langpair=en|$targetLanguageCode"),
      );
      final responseSolidLabel = await http.get(
        Uri.parse("$translateApiUrl?q=${Uri.encodeComponent("Solid")}&langpair=en|$targetLanguageCode"),
      );
      final responseNextButtonText = await http.get(
        Uri.parse("$translateApiUrl?q=${Uri.encodeComponent("Next Question")}&langpair=en|$targetLanguageCode"),
      );

      if (responseTitleText.statusCode == 200 && 
          responseInstructionText.statusCode == 200 &&
          responseCheckButtonText.statusCode == 200 && 
          responseResetButtonText.statusCode == 200 &&
          responseCorrectDialogTitle.statusCode == 200 && 
          responseWrongDialogTitle.statusCode == 200 &&
          responseGasLabel.statusCode == 200 && 
          responseSolidLabel.statusCode == 200 &&
          responseNextButtonText.statusCode == 200) {
        setState(() {
          titleText = jsonDecode(responseTitleText.body)["responseData"]["translatedText"];
          instructionText = jsonDecode(responseInstructionText.body)["responseData"]["translatedText"];
          checkButtonText = jsonDecode(responseCheckButtonText.body)["responseData"]["translatedText"];
          resetButtonText = jsonDecode(responseResetButtonText.body)["responseData"]["translatedText"];
          correctDialogTitle = jsonDecode(responseCorrectDialogTitle.body)["responseData"]["translatedText"];
          wrongDialogTitle = jsonDecode(responseWrongDialogTitle.body)["responseData"]["translatedText"];
          gasLabel = jsonDecode(responseGasLabel.body)["responseData"]["translatedText"];
          solidLabel = jsonDecode(responseSolidLabel.body)["responseData"]["translatedText"];
          nextButtonText = jsonDecode(responseNextButtonText.body)["responseData"]["translatedText"];
        });
      }
    } catch (e) {
      debugPrint("Translation Error: $e");
    }
  }

  void selectLeft(String item) {
    setState(() {
      selectedLeft = item;
      tryMakeConnection();
    });
  }

  void selectRight(String item) {
    setState(() {
      selectedRight = item;
      tryMakeConnection();
    });
  }

  void tryMakeConnection() {
    if (selectedLeft != null && selectedRight != null) {
      setState(() {
        userConnections[selectedLeft!] = selectedRight!;
        selectedLeft = null;
        selectedRight = null;
      });
    }
  }

  void resetGame() {
    setState(() {
      userConnections.clear();
      selectedLeft = null;
      selectedRight = null;
    });
  }

  void checkAnswers() {
    if (userConnections["WaterVapor"] == "Gas" && userConnections["IceCube"] == "Solid") {
      // All correct!
      _confettiController.play();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(correctDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Water vapor is a gas, and ice cubes are solid! 🧊☁️"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  QuizNavigator.navigateNext(context, 6);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text(nextButtonText),
              ),
            ],
          ),
        ),
      );
    } else {
      // Something is wrong
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(wrongDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Check your answers again!"),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        ),
      );
    }
  }

  Offset getWidgetPosition(GlobalKey key) {
    if (key.currentContext == null) {
      return Offset.zero;
    }
    final RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
    final position = box.localToGlobal(Offset.zero);
    return position + Offset(box.size.width / 2, box.size.height / 2);
  }

  void goToNextPage() {
    QuizNavigator.navigateNext(context, 6);
  }

  Future<void> speak(String text) async {
    await flutterTts.stop();
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            QuizNavigator.navigateBack(context, 6);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(titleText),
            DropdownButton<String>(
              value: selectedLanguage,
              icon: const Icon(Icons.language, color: Colors.white),
              dropdownColor: Colors.blue.shade300,
              style: const TextStyle(color: Colors.white),
              underline: Container(height: 0),
              items: [
                {"name": "English", "code": "en"},
                {"name": "Spanish", "code": "es"},
                {"name": "Afrikaans", "code": "af"},
              ].map((lang) {
                return DropdownMenuItem<String>(
                  value: lang["name"]!,
                  child: Text(
                    lang["name"]!,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
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
                    // Reset back to original English
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
      body: Stack(
        children: [
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: LinePainter(
                  userConnections,
                  getWidgetPosition(waterVaporKey),
                  getWidgetPosition(iceCubeKey),
                  getWidgetPosition(gasKey),
                  getWidgetPosition(solidKey),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Progress indicator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      const Text(
                        "6/8",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: 6/8, // Sixth question out of 8
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
                
                Text(
                  instructionText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          key: waterVaporKey,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: GestureDetector(
                            onTap: () => selectLeft("WaterVapor"),
                            child: Container(
                              padding: const EdgeInsets.all(5),
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
                                width: 180,
                                height: 180,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          key: iceCubeKey,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: GestureDetector(
                            onTap: () => selectLeft("IceCube"),
                            child: Container(
                              padding: const EdgeInsets.all(5),
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
                                width: 180,
                                height: 180,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 100),
                    Column(
                      children: [
                        Container(
                          key: gasKey,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: GestureDetector(
                            onTap: () {
                              speak("Gas");
                              selectRight("Gas");
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
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
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          key: solidKey,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: GestureDetector(
                            onTap: () {
                              speak("Solid");
                              selectRight("Solid");
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
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
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        checkButtonText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: resetGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        resetButtonText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: goToNextPage,
                  icon: const Icon(Icons.navigate_next),
                  label: Text(nextButtonText),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(200, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
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
      this.connections, this.waterVaporPos, this.iceCubePos, this.gasPos, this.solidPos);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (var entry in connections.entries) {
      Offset start = Offset.zero;
      Offset end = Offset.zero;

      if (entry.key == "WaterVapor") {
        start = waterVaporPos;
      } else if (entry.key == "IceCube") {
        start = iceCubePos;
      }

      if (entry.value == "Gas") {
        end = gasPos;
      } else if (entry.value == "Solid") {
        end = solidPos;
      }

      if (start != Offset.zero && end != Offset.zero) {
        // Draw an S-curved line for better appearance
        final distance = (end.dx - start.dx).abs();
        final midX = start.dx + (end.dx - start.dx) / 2;
        
        final path = Path()
          ..moveTo(start.dx, start.dy)
          ..cubicTo(
            midX - distance / 6, start.dy,
            midX + distance / 6, end.dy,
            end.dx, end.dy
          );
          
        canvas.drawPath(path, paint);
        
        final dotPaint = Paint()
          ..color = Colors.blue.shade700
          ..style = PaintingStyle.fill;
          
        canvas.drawCircle(start, 4, dotPaint);
        canvas.drawCircle(end, 4, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
