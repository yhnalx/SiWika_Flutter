class StreakManager {
  static int currentStreak = 0;
  static DateTime? lastActiveDate;

  static void registerActivity() {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    if (lastActiveDate == null) {
      // First ever activity
      currentStreak = 1;
    } else {
      final last = DateTime(
        lastActiveDate!.year,
        lastActiveDate!.month,
        lastActiveDate!.day,
      );

      final difference = todayDate.difference(last).inDays;

      if (difference == 1) {
        // Consecutive day
        currentStreak++;
      } else if (difference > 1) {
        // Missed a day
        currentStreak = 1;
      }
      // difference == 0 → already counted today
    }

    lastActiveDate = todayDate;
  }
}
