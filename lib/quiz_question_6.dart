import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'main.dart';

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
  }

  @override
  void dispose() {
    _confettiController.dispose();
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
          // Remove LayoutBuilder; use Positioned.fill for a definite size:
          Positioned.fill(
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
                        GestureDetector(
                          onTap: () => selectLeft("WaterVapor"),
                          child: Container(
                            key: waterVaporKey,
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
                              width: 200,
                              height: 200,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        GestureDetector(
                          onTap: () => selectLeft("IceCube"),
                          child: Container(
                            key: iceCubeKey,
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
                              width: 200,
                              height: 200,
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
                        const SizedBox(height: 40),
                        GestureDetector(
                          onTap: () => selectRight("Solid"),
                          child: Container(
                            key: solidKey,
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
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

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
        canvas.drawLine(start, end, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
