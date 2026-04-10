import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../models/scene.dart';

class _HistoryStep {
  final String sceneId;
  final bool counted;
  final bool wasCorrect;

  const _HistoryStep({
    required this.sceneId,
    required this.counted,
    required this.wasCorrect,
  });
}

class GameState extends ChangeNotifier {
  List<Scene> _scenes = [];
  Scene? _currentScene;
  Scene? get currentScene => _currentScene;

  int _totalCorrect = 0;
  int get totalCorrect => _totalCorrect;

  int _totalAnswered = 0;
  int get totalAnswered => _totalAnswered;

  int get totalScenes => _scenes.length;

  final List<_HistoryStep> _history = [];

  Future<void> loadScenes() async {
    final jsonString = await rootBundle.loadString('lib/data/scene.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    _scenes = jsonList.map((s) => Scene.fromJson(s)).toList();
    _currentScene = _scenes.first;
    _history.clear();
    _totalCorrect = 0;
    _totalAnswered = 0;
    notifyListeners();
  }

  bool get isGameOver {
    final id = _currentScene?.id;
    return id == 'correct' || id == 'incorrect';
  }

  String? get hintVerse {
    final id = _currentScene?.id;
    if (id == null) return null;

    const hintsBySceneId = <String, String>{
      'gethsemane': 'Matthew 26:39 — "Yet not as I will, but as you will."',
      'jesus_arrest': 'John 18:11 — "Shall I not drink the cup the Father has given me?"',
      'before_pilate': 'Luke 23:24 — "So Pilate decided to grant their demand."',
      'jesus_carries_cross': 'John 19:17 — "Carrying his own cross, he went out..."',
      'simon_help': 'Luke 23:26 — "They seized Simon... and put the cross on him..."',
      'crucifixion': 'John 19:26-27 — "Woman, here is your son... here is your mother."',
      'burial': 'Matthew 27:59-60 — "Joseph took the body... and laid it in his own new tomb."',
      'resurrection': 'Matthew 28:6 — "He is not here; he has risen..."',
    };

    return hintsBySceneId[id];
  }

  bool get canGoBack => _history.isNotEmpty;

  bool _isPreviousChoice(Choice choice) {
    final t = choice.text.trim().toLowerCase();
    return t == 'previous scene' || t == 'previous' || t.startsWith('previous ');
  }

  bool _shouldCountChoice(Choice choice) {
    final sceneId = _currentScene?.id;
    if (sceneId == null) return false;
    if (sceneId == 'start_screen') return false;
    if (sceneId == 'correct' || sceneId == 'incorrect') return false;
    if (_isPreviousChoice(choice)) return false;
    return true;
  }

  void makeChoice(Choice choice) {
    if (_currentScene == null) return;

    if (_isPreviousChoice(choice)) {
      goBack();
      return;
    }

    final counted = _shouldCountChoice(choice);
    final wasCorrect = choice.outcomeSceneId != 'incorrect';

    if (counted) {
      _totalAnswered += 1;
      if (wasCorrect) _totalCorrect += 1;
      _history.add(
        _HistoryStep(sceneId: _currentScene!.id, counted: true, wasCorrect: wasCorrect),
      );
    } else {
      _history.add(
        _HistoryStep(sceneId: _currentScene!.id, counted: false, wasCorrect: false),
      );
    }

    _currentScene = _scenes.firstWhere((s) => s.id == choice.outcomeSceneId);
    notifyListeners();
  }

  void goBack() {
    if (_currentScene == null) return;
    if (_history.isEmpty) return;

    final last = _history.removeLast();
    if (last.counted) {
      _totalAnswered = (_totalAnswered - 1).clamp(0, 1 << 30);
      if (last.wasCorrect) {
        _totalCorrect = (_totalCorrect - 1).clamp(0, 1 << 30);
      }
    }

    _currentScene = _scenes.firstWhere((s) => s.id == last.sceneId);
    notifyListeners();
  }

  void reset() {
    _currentScene = _scenes.first;
    _history.clear();
    _totalCorrect = 0;
    _totalAnswered = 0;
    notifyListeners();
  }
}

