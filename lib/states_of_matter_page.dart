import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'quiz_question_1.dart';

class StatesOfMatterPage extends StatefulWidget {
  const StatesOfMatterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StatesOfMatterPageState createState() => _StatesOfMatterPageState();
}

class _StatesOfMatterPageState extends State<StatesOfMatterPage> {
  String selectedLanguage = "English";
  String titleText = "Science Fun";
  String statesOfMatterText = "States of Matter";
  String chapterOverviewText = "Chapter Overview";
  String chapterDescription = "🌍 Matter exists in three states: 🧊 Solid (fixed shape & volume), 💧 Liquid (takes container’s shape), and ☁️ Gas (fills any space). 🍦 Ice cream melts, just like water turns to steam 🔥 when heated. 🌦️ Water falls as rain 💦, freezes ❄️ in cold, and evaporates ☀️ in heat. These changes help us understand our world! 🌎✨";
  String quizButtonText = "Start Chapter Quiz";
  final String translateApiUrl = "https://api.mymemory.translated.net/get";

  Future<void> translateText(String targetLanguageCode) async {
    try {
      final response = await http.get(
        Uri.parse("$translateApiUrl?q=${Uri.encodeComponent("States of Matter")}&langpair=en|$targetLanguageCode"),
      );
      final chapterResponse = await http.get(
        Uri.parse("$translateApiUrl?q=${Uri.encodeComponent("Chapter Overview")}&langpair=en|$targetLanguageCode"),
      );
      final descriptionResponse = await http.get(
        Uri.parse("$translateApiUrl?q=${Uri.encodeComponent(chapterDescription)}&langpair=en|$targetLanguageCode"),
      );
      final quizButtonResponse = await http.get(
        Uri.parse("$translateApiUrl?q=${Uri.encodeComponent("Start Chapter Quiz")}&langpair=en|$targetLanguageCode"),
      );

      if (response.statusCode == 200 && chapterResponse.statusCode == 200 && descriptionResponse.statusCode == 200 && quizButtonResponse.statusCode == 200) {
        setState(() {
          statesOfMatterText = jsonDecode(response.body)["responseData"]["translatedText"];
          chapterOverviewText = jsonDecode(chapterResponse.body)["responseData"]["translatedText"];
          chapterDescription = jsonDecode(descriptionResponse.body)["responseData"]["translatedText"];
          quizButtonText = jsonDecode(quizButtonResponse.body)["responseData"]["translatedText"];
        });
      }
    } catch (e) {
      debugPrint("Translation Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    titleText,
                    style: TextStyle(
                      fontFamily: 'ComicSansMS',
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedLanguage,
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
                          setState(() {
                            statesOfMatterText = "States of Matter";
                            chapterOverviewText = "Chapter Overview";
                            chapterDescription = "In this chapter, we’ll explore the three states of matter: solid, liquid, and gas... This is going to be an exciting journey into the world of matter!";
                            quizButtonText = "Start Chapter Quiz";
                          });
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 80.0, top: 8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/experiment.png',
                    width: double.infinity,
                    height: 270,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        statesOfMatterText,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset('assets/icecube.jpeg', fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset('assets/waterdrop.jpg', fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset('assets/cloud.png', fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chapterOverviewText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        chapterDescription,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => IceCreamQuiz()),
                          );
                        },
                        icon: const Icon(Icons.help),
                        label: Text(quizButtonText),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
