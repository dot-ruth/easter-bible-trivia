import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_state.dart';

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

return SafeArea(
  child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          ),
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.brown[300],
            image: DecorationImage(
              opacity: 0.5,
              image: AssetImage(scene!.imagePath),
              fit: BoxFit.fill
              ),
          ),
          child: Padding(
            
            padding: const EdgeInsets.all(50.0),
            
            child: Column(
              
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  scene.narrative, 
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600
                    )
                    ),
                const SizedBox(height: 20),
                ...scene.choices.map((choice) {
                  return ElevatedButton(
                    onPressed: () {
                      gameState.makeChoice(choice);
                    },
                    child: Text(
                      choice.text,
                      style: TextStyle(color: Colors.black),
                      ),
                  );
                })
              ],
            ),
          ),
        ),
      ),
);
  }
}
