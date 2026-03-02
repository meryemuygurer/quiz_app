import 'package:flutter/material.dart';

// Basit bir Question modeli
class Question {
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;

  Question({
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
  });
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  int score = 0;

  // Örnek sorular
  final List<Question> questions = [
    Question(
      questionText: 'Flutter hangi programlama dilini kullanır?',
      options: ['Java', 'Dart', 'Kotlin', 'Swift'],
      correctOptionIndex: 1,
    ),
    Question(
      questionText: 'Widget nedir?',
      options: ['Arayüz öğesi', 'Veritabanı', 'Sunucu', 'Dosya sistemi'],
      correctOptionIndex: 0,
    ),
    Question(
      questionText: 'Stateful widget ne zaman kullanılır?',
      options: [
        'Değişmeyen veri için',
        'Değişen veri için',
        'Her zaman',
        'Hiçbir zaman',
      ],
      correctOptionIndex: 1,
    ),
  ];

  void answerQuestion(int selectedIndex) {
    if (selectedIndex == questions[currentQuestionIndex].correctOptionIndex) {
      score++;
    }

    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        // Quiz bitti
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text('Quiz Bitti!'),
                content: Text('Skorunuz: $score/${questions.length}'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        currentQuestionIndex = 0;
                        score = 0;
                      });
                    },
                    child: const Text('Tekrar Oyna'),
                  ),
                ],
              ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Quiz App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Soru ${currentQuestionIndex + 1}/${questions.length}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(question.questionText, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ...List.generate(
              question.options.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ElevatedButton(
                  onPressed: () => answerQuestion(index),
                  child: Text(question.options[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
