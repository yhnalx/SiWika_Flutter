import 'package:flutter/material.dart';
import 'package:si_wika/screens/quizsummary_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<Map<String, dynamic>> questions = [
    {
      "question": "What is the sign for Hello?",
      "choices": ["👋 Wave", "🙏 Pray", "✊ Fist", "☝️ Tap"],
      "answer": 0, // Points to "👋 Wave"
    },
    {
      "question": "What does 🙏 mean?",
      "choices": ["Hello", "No", "Thank You", "Yes"],
      "answer": 2, // Points to "Thank You"
    },
  ];

  int index = 0;
  int? selectedIndex;
  bool isAnswered = false;
  int score = 0;

  // This holds the shuffled choices for the current question
  List<String> randomizedChoices = [];

  @override
  void initState() {
    super.initState();
    _prepareQuestion();
  }

  // Shuffles choices and resets selection
  void _prepareQuestion() {
    List<String> choices = List<String>.from(questions[index]["choices"]);
    choices.shuffle();
    setState(() {
      randomizedChoices = choices;
    });
  }

  void handleCheck() {
    if (selectedIndex == null) return;

    // Identify the correct text based on the original data index
    final String correctText =
        questions[index]["choices"][questions[index]["answer"]];
    final String selectedText = randomizedChoices[selectedIndex!];
    final bool isCorrect = selectedText == correctText;

    setState(() {
      isAnswered = true;
      if (isCorrect) {
        score++;
      }
    });

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      barrierColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 160,
          decoration: BoxDecoration(
            color: isCorrect
                ? const Color(0xFFD7FFB8)
                : const Color(0xFFFFDFE0),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    isCorrect ? Icons.check_circle : Icons.cancel,
                    color: isCorrect
                        ? const Color(0xFF58CC02)
                        : const Color(0xFFEE5555),
                    size: 35,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isCorrect ? "Excellent!" : "Correct solution:",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: isCorrect
                          ? const Color(0xFF46A302)
                          : const Color(0xFFEE5555),
                    ),
                  ),
                ],
              ),
              if (!isCorrect)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 47, top: 4),
                    child: Text(
                      correctText,
                      style: const TextStyle(
                        color: Color(0xFFEE5555),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              const Spacer(),
              _buildChunkyButton(
                label: "CONTINUE",
                color: isCorrect
                    ? const Color(0xFF58CC02)
                    : const Color(0xFFEE5555),
                shadowColor: isCorrect
                    ? const Color(0xFF46A302)
                    : const Color(0xFFC34040),
                onPressed: () {
                  Navigator.pop(context);
                  nextQuestion();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void nextQuestion() {
    if (index < questions.length - 1) {
      setState(() {
        index++;
        selectedIndex = null;
        isAnswered = false;
      });
      _prepareQuestion(); // Re-shuffle for the next round
    } else {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            QuizSummaryScreen(score: score, totalQuestions: questions.length),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[index];
    double progress = (index + 1) / questions.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFFAFAFAF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 12,
            backgroundColor: const Color(0xFFE5E5E5),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF58CC02)),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.favorite, color: Color(0xFFFF4B4B), size: 28),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select the correct meaning",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xFF4B4B4B),
              ),
            ),
            const SizedBox(height: 32),

            // Question Display
            Center(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE5E5E5), width: 2),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Color(0xFFE5E5E5), offset: Offset(0, 4)),
                  ],
                ),
                child: Text(
                  q["question"],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Randomized Choices
            Expanded(
              child: ListView.builder(
                itemCount: randomizedChoices.length,
                itemBuilder: (context, i) {
                  bool isSelected = selectedIndex == i;
                  return _buildOptionButton(
                    randomizedChoices[i],
                    i,
                    isSelected,
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Check Button
            _buildChunkyButton(
              label: "CHECK",
              color: selectedIndex == null
                  ? const Color(0xFFE5E5E5)
                  : const Color(0xFF58CC02),
              shadowColor: selectedIndex == null
                  ? const Color(0xFFE5E5E5)
                  : const Color(0xFF46A302),
              textColor: selectedIndex == null
                  ? const Color(0xFFAFAFAF)
                  : Colors.white,
              onPressed: selectedIndex == null ? null : handleCheck,
            ),
          ],
        ),
      ),
    );
  }

  // Reusable 3D button style
  Widget _buildChunkyButton({
    required String label,
    required Color color,
    required Color shadowColor,
    required VoidCallback? onPressed,
    Color textColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            if (onPressed != null)
              BoxShadow(color: shadowColor, offset: const Offset(0, 4)),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(String text, int i, bool isSelected) {
    return GestureDetector(
      onTap: isAnswered ? null : () => setState(() => selectedIndex = i),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE1F5FE) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1CB0F6)
                : const Color(0xFFE5E5E5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFF1899D6)
                  : const Color(0xFFE5E5E5),
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? const Color(0xFF1CB0F6)
                  : const Color(0xFF4B4B4B),
            ),
          ),
        ),
      ),
    );
  }
}
