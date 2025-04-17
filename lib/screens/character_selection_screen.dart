import 'package:flutter/material.dart';
import '../data/characters.dart';
import '../models/character.dart';
import 'scene_screen.dart';
import '../providers/game_state.dart';
import 'package:provider/provider.dart';

class CharacterSelectionScreen extends StatelessWidget {
  const CharacterSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Choose Your Character')),
      body: ListView.builder(
        itemCount: characters.length,
        itemBuilder: (context, index) {
          Character character = characters[index];

          return Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              // leading: Image.asset(character.imagePath, height: 60),
              title: Text(character.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(character.description),
              onTap: () {
                gameState.selectCharacter(character.name);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SceneScreen()),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
