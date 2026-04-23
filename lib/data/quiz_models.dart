class QuizOption {
  final String textEn;
  final String textEs;
  final String? image;

  const QuizOption({
    required this.textEn,
    required this.textEs,
    this.image,
  });
}

class QuizQuestion {
  final String questionEn;
  final String questionEs;
  final String? questionImage;
  final List<QuizOption> options;
  final int correctIndex;

  const QuizQuestion({
    required this.questionEn,
    required this.questionEs,
    this.questionImage,
    required this.options,
    required this.correctIndex,
  });
}

class QuizConfig {
  final String titleEn;
  final String titleEs;
  final List<QuizQuestion> questions;
  final int questionsPerRound;
  final int timePerQuestion;

  const QuizConfig({
    required this.titleEn,
    required this.titleEs,
    required this.questions,
    this.questionsPerRound = 10,
    this.timePerQuestion = 15,
  });
}
