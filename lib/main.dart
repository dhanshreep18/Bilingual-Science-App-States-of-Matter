import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class StatesOfMatterPage extends StatelessWidget {
  const StatesOfMatterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // We use a custom app bar in place of the 'header' from the HTML.
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: Column(
          children: [
            // Top Version/Language Container
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Container(
                color: Colors.blue.shade50,
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Version 7: Choose your preferred language for content and subtitles',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            // Main App Bar Content
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // "Science Fun" brand text
                  Text(
                    'Science Fun',
                    style: TextStyle(
                      fontFamily: 'Pacifico',
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  // Language DropDown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: DropdownButton<String>(
                      underline: const SizedBox(),
                      value: 'English',
                      items: const [
                        DropdownMenuItem(
                          value: 'English',
                          child: Text('English'),
                        ),
                        DropdownMenuItem(
                          value: 'Spanish',
                          child: Text('Spanish'),
                        ),
                        DropdownMenuItem(
                          value: 'French',
                          child: Text('French'),
                        ),
                      ],
                      onChanged: (value) {
                        // Handle language change
                      },
                    ),
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
              // Video Thumbnail Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'https://creatie.ai/ai/api/search-image?query=animated+cartoon+style+educational+video+...',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.3),
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                // Handle play
                              },
                              icon: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 48,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // CC, Audio, Download Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildIconButton(
                      icon: Icons.closed_caption,
                      label: 'CC',
                    ),
                    const SizedBox(width: 8),
                    _buildIconButton(
                      icon: Icons.volume_up,
                      label: 'Audio',
                    ),
                    const SizedBox(width: 8),
                    _buildIconButton(
                      icon: Icons.download,
                      label: 'Download',
                    ),
                  ],
                ),
              ),

              // "States of Matter" Section
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
                      // Title
                      const Text(
                        'States of Matter',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Horizontal scroll of images
                      SizedBox(
                        height: 140,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildStateCard(
                              imageUrl:
                                  'https://creatie.ai/ai/api/search-image?query=cute+cartoon+ice+cube+...',
                              label: 'Solid',
                            ),
                            _buildStateCard(
                              imageUrl:
                                  'https://creatie.ai/ai/api/search-image?query=cute+cartoon+water+droplet+...',
                              label: 'Liquid',
                            ),
                            _buildStateCard(
                              imageUrl:
                                  'https://creatie.ai/ai/api/search-image?query=cute+cartoon+cloud+character+...',
                              label: 'Gas',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Progress and Points
                      Row(
                        children: const [
                          Icon(Icons.star, color: Colors.yellow),
                          SizedBox(width: 8),
                          Text(
                            'Progress: Chapter 1/3',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.emoji_events, color: Colors.blue.shade600),
                          const SizedBox(width: 8),
                          const Text(
                            'Points: 150',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Chapter Overview
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
                      const Text(
                        'Chapter Overview',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "In this chapter, we’ll explore the three states of matter: solid, liquid, and gas..."
                        "This is going to be an exciting journey into the world of matter!",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      // Bullet points
                      const Text(
                        "🧊 Solids: Fixed shape and volume\n"
                        "💧 Liquids: Take container's shape, fixed volume\n"
                        "☁️ Gases: Spread out to fill any container",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Think about ice cream on a hot day... matter can change from one state to another!",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Have you ever watched steam rise from a pot of boiling water... "
                        "When these molecules cool down... that's why we see steam!",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "In nature, we see these changes happening all around us... "
                        "Understanding these changes helps us understand how our world works!",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      // Start Chapter Quiz Button
                      ElevatedButton.icon(
                        onPressed: () {
                          // Start quiz
                        },
                        icon: const Icon(Icons.help),
                        label: const Text('Start Chapter Quiz'),
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

      // Bottom Navigation
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home,
                label: 'Home',
                isActive: true,
              ),
              _buildNavItem(
                icon: Icons.menu_book,
                label: 'Lessons',
                isActive: false,
              ),
              _buildNavItem(
                icon: Icons.quiz,
                label: 'Quiz',
                isActive: false,
              ),
              _buildNavItem(
                icon: Icons.emoji_events,
                label: 'Rewards',
                isActive: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper widget to build the small buttons (CC, Audio, Download).
  Widget _buildIconButton({required IconData icon, required String label}) {
    return OutlinedButton.icon(
      onPressed: () {
        // handle click
      },
      icon: Icon(icon, size: 18, color: Colors.black87),
      label: Text(label, style: const TextStyle(fontSize: 14)),
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.blue.shade50,
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Helper widget to build each state card (Solid, Liquid, Gas).
  Widget _buildStateCard({required String imageUrl, required String label}) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// Helper to build each bottom navigation item.
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    final activeColor = Colors.black;
    final inactiveColor = Colors.grey.shade400;

    return InkWell(
      onTap: () {
        // handle nav
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? activeColor : inactiveColor,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? activeColor : inactiveColor,
            ),
          ),
        ],
      ),
    );
  }
}


// class StatesOfMatterPage extends StatelessWidget {
//   const StatesOfMatterPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // -- example code from the previous snippet
//       appBar: AppBar(
//         title: const Text('Science Fun'),
//       ),
//       body: Center(
//         child: Text('Your States of Matter Content Here'),
//       ),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
