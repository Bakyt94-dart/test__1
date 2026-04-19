import 'package:flutter/material.dart';
import 'card_model.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final List<CardModel> cards = [
    CardModel(color: Colors.blue),
    CardModel(color: Colors.red),
    CardModel(color: Colors.blue),
    CardModel(color: Colors.red),
  ];

  int errorCount = 0;
  int? firstIndex;
  String statusText = "";
  bool canClick = true;

  void onCardTap(int index) {
    if (!canClick ||
        cards[index].isOpened ||
        cards[index].isSolved ||
        errorCount >= 2)
      return;

    setState(() {
      cards[index].isOpened = true;
    });

    if (firstIndex == null) {
      firstIndex = index;
    } else {
      _checkMatch(index);
    }
  }

  void _checkMatch(int secondIndex) {
    if (cards[firstIndex!].color == cards[secondIndex].color) {
      setState(() {
        cards[firstIndex!].isSolved = true;
        cards[secondIndex].isSolved = true;
        statusText = "Успешно";
        firstIndex = null;
      });
    } else {
      errorCount++;
      if (errorCount >= 2) {
        setState(() {
          statusText = "У вас не осталось попыток";
        });
      } else {
        canClick = false;
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            cards[firstIndex!].isOpened = false;
            cards[secondIndex].isOpened = false;
            firstIndex = null;
            canClick = true;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Игра 'Найти пару'"), centerTitle: true),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            "Ошибок: $errorCount / 2",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
              ),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => onCardTap(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: (cards[index].isOpened || cards[index].isSolved)
                          ? cards[index].color
                          : Colors.grey[400],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: Text(
              statusText,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: statusText == "Успешно" ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
