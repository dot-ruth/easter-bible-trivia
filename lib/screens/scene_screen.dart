import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_state.dart';
// import '../models/scene.dart';

class SceneScreen extends StatelessWidget {
  const SceneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);

  if (gameState.currentScene == null) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }


    final scene = gameState.currentScene;

    return Scaffold(
      appBar: AppBar(title: const Text('Hearts Redeemed')),
      body: Padding(
        
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(scene!.narrative, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ...scene.choices.map((choice) {
              return ElevatedButton(
                onPressed: () {
                  gameState.makeChoice(choice);
                },
                child: Text(choice.text),
              );
            }).toList(),
            const Spacer(),
            Text("You are playing as: ${gameState.selectedCharacter}"),
            Text("Spiritual Awareness: ${gameState.understandingScore}"),
          ],
        ),
      ),
    );
  }
}
