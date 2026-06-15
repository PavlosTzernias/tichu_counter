import 'package:flutter/material.dart';
import 'settings_dialog.dart';
import '../models/game.dart';
import '../services/storage_service.dart';

class GamePage extends StatefulWidget {
  final Game game;

  const GamePage({
    super.key,
    required this.game,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final TextEditingController aController = TextEditingController();
  final TextEditingController bController = TextEditingController();

  bool _updating = false;

  int baseA = 0;
  int baseB = 0;

  int bonusA = 0;
  int bonusB = 0;

  int get displayA => baseA + bonusA;
  int get displayB => baseB + bonusB;

  void _openSettings(BuildContext pageContext, BuildContext drawerContext) {
    Navigator.pop(drawerContext);
    showSettingsDialog(pageContext);
  }

  void _showComingSoonDialog(
    BuildContext pageContext,
    BuildContext drawerContext,
    String title,
  ) {
    Navigator.pop(drawerContext);

    showDialog<void>(
      context: pageContext,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: const Text("Θα το φτιάξουμε αργότερα."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _openCounter(BuildContext drawerContext) {
    Navigator.pop(drawerContext);
  }

  void _openHome(BuildContext drawerContext) {
    Navigator.pop(drawerContext);
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void addBonusA(int value) {
    setState(() {
      bonusA += value;
    });
  }

  void addBonusB(int value) {
    setState(() {
      bonusB += value;
    });
  }

  Future<void> submitRound() async {
    if (baseA == 0 && baseB == 0 && bonusA == 0 && bonusB == 0) {
      return;
    }

    widget.game.addRound(
      aPoints: displayA,
      bPoints: displayB,
      aBonus: null,
      bBonus: null,
    );

    setState(() {
      baseA = 0;
      baseB = 0;
      bonusA = 0;
      bonusB = 0;

      aController.clear();
      bController.clear();
    });

    await StorageService().saveLastGame(widget.game);
  }

  Widget bonusButton(String text, int value, bool isA) {
    return ElevatedButton(
      onPressed: () {
        if (isA) {
          addBonusA(value);
        } else {
          addBonusB(value);
        }
      },
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final game = widget.game;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tichu Score"),
      ),
      drawer: Drawer(
        child: Builder(
          builder: (drawerContext) {
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Tichu Score",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text("Home"),
                  onTap: () => _openHome(drawerContext),
                ),
                ListTile(
                  leading: const Icon(Icons.calculate),
                  title: const Text("Counter"),
                  onTap: () => _openCounter(drawerContext),
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text("Ρυθμίσεις"),
                  onTap: () => _openSettings(context, drawerContext),
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text("About"),
                  onTap: () => _showComingSoonDialog(
                    context,
                    drawerContext,
                    "About",
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(game.teamA),
                    Text(
                      "${game.totalA}",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(game.teamB),
                    Text(
                      "${game.totalB}",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: game.rounds.length,
              itemBuilder: (context, index) {
                final r = game.rounds[index];

                return ListTile(
                  leading: Text("${index + 1}"),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${r.teamAScore}"),
                      Text("${r.teamBScore}"),
                    ],
                  ),
                );
              },
            ),
          ),

          const Divider(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: aController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: game.teamA,
                      helperText: "Τελικό: $displayA",
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      if (_updating) return;

                      _updating = true;

                      baseA = int.tryParse(value) ?? 0;
                      baseB = 100 - baseA;

                      bController.text = baseB.toString();

                      _updating = false;

                      setState(() {});
                    },
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: TextField(
                    controller: bController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: game.teamB,
                      helperText: "Τελικό: $displayB",
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      if (_updating) return;

                      _updating = true;

                      baseB = int.tryParse(value) ?? 0;
                      baseA = 100 - baseB;

                      aController.text = baseA.toString();

                      _updating = false;

                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          bonusButton("+100", 100, true),
                          bonusButton("-100", -100, true),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          bonusButton("+200", 200, true),
                          bonusButton("-200", -200, true),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          bonusButton("+100", 100, false),
                          bonusButton("-100", -100, false),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          bonusButton("+200", 200, false),
                          bonusButton("-200", -200, false),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.only(bottom: 48),
            child: ElevatedButton(
              onPressed: submitRound,
              child: const Text("Καταχώρηση"),
            ),
          ),
        ],
      ),
    );
  }
}
