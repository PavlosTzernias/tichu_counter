import 'package:flutter/material.dart';
import 'game_page.dart';
import 'new_game_page.dart';
import 'settings_dialog.dart';
import '../services/storage_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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

  Future<void> _loadLastGame(BuildContext context) async {
    final game = await StorageService().loadLastGame();

    if (!context.mounted) return;

    if (game == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No saved game found")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GamePage(game: game)),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "TICHU SCORE",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NewGamePage()),
                );
              },
              child: const Text("NEW GAME"),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () => _loadLastGame(context),
              child: const Text("LOAD LAST GAME"),
            ),
          ],
        ),
      ),
    );
  }
}
