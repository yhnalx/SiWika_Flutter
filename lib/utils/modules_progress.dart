class ModuleProgress {
  static final Map<String, Set<String>> _completedLetters = {
    "fsl_alphabet": {},
    "fsl_phrases": {},
  };

  static void markCompleted(String moduleId, String letter) {
    _completedLetters[moduleId]?.add(letter);
  }

  static int completedCount(String moduleId) {
    return _completedLetters[moduleId]?.length ?? 0;
  }

  static bool isModuleComplete(String moduleId, int total) {
    return completedCount(moduleId) >= total;
  }
}
