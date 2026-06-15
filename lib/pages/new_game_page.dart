import 'package:flutter/material.dart';
import 'game_page.dart';
import '../models/game.dart';
import '../services/storage_service.dart';

class NewGamePage extends StatefulWidget {
  const NewGamePage({super.key});

  @override
  State<NewGamePage> createState() => _NewGamePageState();
}

class _NewGamePageState extends State<NewGamePage> {
  final teamAController = TextEditingController();
  final teamBController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Game")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: teamAController,
              decoration: const InputDecoration(labelText: "Team A"),
            ),
            TextField(
              controller: teamBController,
              decoration: const InputDecoration(labelText: "Team B"),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final game = Game(
                  teamA: teamAController.text,
                  teamB: teamBController.text,
                );

                await StorageService().saveLastGame(game);

                if (!context.mounted) return;

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GamePage(game: game),
                  ),
                );
              },
              child: const Text("START GAME"),
            )
          ],
        ),
      ),
    );
  }
}
