import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/game.dart';

class StorageService {
  static const _lastGameKey = 'last_game';

  Future<void> saveLastGame(Game game) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastGameKey, jsonEncode(game.toJson()));
  }

  Future<Game?> loadLastGame() async {
    final prefs = await SharedPreferences.getInstance();
    final savedGame = prefs.getString(_lastGameKey);

    if (savedGame == null) {
      return null;
    }

    try {
      return Game.fromJson(jsonDecode(savedGame) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}
