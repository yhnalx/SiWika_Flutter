import 'package:flutter/material.dart';
import '../data/fsl_alphabet.dart';
import '../utils/streak_manager.dart';

class AlphabetQuizScreen extends StatefulWidget {
  const AlphabetQuizScreen({super.key});

  @override
  State<AlphabetQuizScreen> createState() => _AlphabetQuizScreenState();
}

class _AlphabetQuizScreenState extends State<AlphabetQuizScreen> {
  int index = 0;
  int score = 0;
  bool answered = false;

  late final questions = FslAlphabet.letters.take(5).map((l) {
    return {
      "question": "What is the sign for ${l["letter"]}?",
      "answer": l["description"],
      "choices": [
        l["description"],
        "Wrong option 1",
        "Wrong option 2",
        "Wrong option 3",
      ]..shuffle(),
    };
  }).toList();

  void select(String choice) {
    if (answered) return;

    setState(() {
      answered = true;
      if (choice == questions[index]["answer"]) score++;
    });
  }

  void next() {
    if (index < questions.length - 1) {
      setState(() {
        index++;
        answered = false;
      });
    } else {
      StreakManager.registerActivity();
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Quiz Finished 🎉"),
          content: Text("Score: $score / ${questions.length}"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[index];

    return Scaffold(
      appBar: AppBar(title: const Text("Alphabet Quiz")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              q["question"].toString(),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ...(q["choices"] != null
                ? (q["choices"] as List).map<Widget>((c) {
                    return ElevatedButton(
                      onPressed: () => select(c),
                      child: Text(c),
                    );
                  }).toList()
                : []),
            const Spacer(),
            ElevatedButton(onPressed: next, child: const Text("Next")),
          ],
        ),
      ),
    );
  }
}
