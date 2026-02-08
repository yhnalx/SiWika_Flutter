import 'package:flutter/material.dart';
import 'package:si_wika/data/fsl_phrases.dart';
import 'package:si_wika/screens/modules_screen.dart';
import 'package:si_wika/screens/practice_screen.dart';
import 'package:si_wika/utils/streak_manager.dart';
import 'quiz_screen.dart';
import 'flashcard_screen.dart';

class DashboardScreen extends StatelessWidget {
  static const route = "/dashboard";

  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final name = (args?["name"] ?? "Learner").toString();

    return Scaffold(
      backgroundColor: Colors.white,
      // DUO STYLE APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            const Icon(
              Icons.local_fire_department,
              color: Colors.orange,
              size: 28,
            ),
            const SizedBox(width: 4),
            Text(
              "${StreakManager.currentStreak}",
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 20),
            const Icon(Icons.stars, color: Colors.blueAccent, size: 28),
            const SizedBox(width: 4),
            const Text(
              "120",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Color(0xFFE5E5E5),
              child: Icon(Icons.person, color: Colors.grey),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi, $name! 👋",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Color(0xFF4B4B4B),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Ready for your daily signs?",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),

            _DuoDashboardCard(
              title: "MODULES",
              subtitle: "Structured lessons",
              icon: Icons.menu_book_rounded,
              color: const Color(0xFF9C27B0), // Purple (stands out nicely)
              shadowColor: const Color(0xFF7B1FA2),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ModulesScreen()),
              ),
            ),

            SizedBox(height: 20),

            // FLASHCARDS CARD
            _DuoDashboardCard(
              title: "REVIEW FLASHCARDS",
              subtitle: "Learn common phrases", // Updated subtitle
              icon: Icons.style_rounded,
              color: const Color(0xFF58CC02),
              shadowColor: const Color(0xFF46A302),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FlashcardScreen(
                    cards: FslPhrases.phrases, // 2. Pass the phrases list
                    moduleId: 'fsl_phrases', // 3. Pass the phrases ID
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            _DuoDashboardCard(
              title: "PRACTICE",
              subtitle: "Practice your gestures",
              icon: Icons.front_hand_rounded,
              color: const Color(0xFFFF9600), // Duo Orange
              shadowColor: const Color(0xFFE88900),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PracticeGesturesScreen(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // QUIZ CARD
            _DuoDashboardCard(
              title: "QUIZ MODE",
              subtitle: "Test your skill",
              icon: Icons.bolt_rounded,
              color: const Color(0xFF1CB0F6), // Duo Blue
              shadowColor: const Color(0xFF1899D6),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QuizScreen()),
              ),
            ),

            const SizedBox(height: 40),

            // CHALLENGE AREA
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: Row(
                children: [
                  Image.network(
                    'https://cdn-icons-png.flaticon.com/512/10308/10308355.png', // A cute mascot icon
                    height: 80,
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "DAILY CHALLENGE",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.orange,
                          ),
                        ),
                        Text("Complete 3 lessons today to earn 20 gems!"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DuoDashboardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color shadowColor;
  final VoidCallback onTap;

  const _DuoDashboardCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.shadowColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              offset: const Offset(0, 6), // That chunky 3D look
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 30),
          ],
        ),
      ),
    );
  }
}
