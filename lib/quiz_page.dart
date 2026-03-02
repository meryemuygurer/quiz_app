import 'package:flutter/material.dart';
import 'dart:async';

// Question model
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
  bool answered = false;
  int selectedAnswerIndex = -1;

  int timeLeft = 15; // 15 seconds per question
  Timer? timer;

  final List<Question> questions = [
    Question(
      questionText: 'Which programming language does Flutter use?',
      options: ['Java', 'Dart', 'Kotlin', 'Swift'],
      correctOptionIndex: 1,
    ),
    Question(
      questionText: 'What is a Widget in Flutter?',
      options: ['UI element', 'Database', 'Server', 'File system'],
      correctOptionIndex: 0,
    ),
    Question(
      questionText: 'When should you use a Stateful widget?',
      options: ['For constant data', 'For changing data', 'Always', 'Never'],
      correctOptionIndex: 1,
    ),
    Question(
      questionText: 'What is Hot Reload used for?',
      options: [
        'See UI changes instantly',
        'Database operations',
        'Backend testing',
        'File management',
      ],
      correctOptionIndex: 0,
    ),
    Question(
      questionText: 'Which platforms can Flutter run on?',
      options: ['iOS & Android', 'Only Android', 'Only iOS', 'Only Web'],
      correctOptionIndex: 0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer?.cancel();
    timeLeft = 15;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        answerQuestion(-1); // Time out = incorrect
      }
    });
  }

  void answerQuestion(int selectedIndex) {
    if (answered) return;
    setState(() {
      selectedAnswerIndex = selectedIndex;
      answered = true;
      if (selectedIndex == questions[currentQuestionIndex].correctOptionIndex) {
        score++;
      }
      timer?.cancel();
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        if (currentQuestionIndex < questions.length - 1) {
          currentQuestionIndex++;
          answered = false;
          selectedAnswerIndex = -1;
          startTimer();
        } else {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder:
                (_) => AlertDialog(
                  title: const Text('Quiz Finished!'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Your score: $score/${questions.length}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        score == questions.length
                            ? '🏆 Perfect!'
                            : (score >= questions.length / 2
                                ? '😊 Good Job!'
                                : '😔 Keep Practicing'),
                        style: const TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          currentQuestionIndex = 0;
                          score = 0;
                          answered = false;
                          selectedAnswerIndex = -1;
                          startTimer();
                        });
                      },
                      child: const Text('Play Again'),
                    ),
                  ],
                ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 600,
          ), // Max width for aesthetics
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Timer
              Text(
                'Time: $timeLeft s',
                style: const TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: (currentQuestionIndex + 1) / questions.length,
                backgroundColor: Colors.white24,
                color: Colors.white,
                minHeight: 10,
              ),
              const SizedBox(height: 30),

              // Question Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    question.questionText,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Options
              ...List.generate(
                question.options.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click, // <-- cursor pointer
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            answered
                                ? (index == question.correctOptionIndex
                                    ? Colors.green
                                    : (index == selectedAnswerIndex
                                        ? Colors.red
                                        : Colors.grey[300]))
                                : Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                      onPressed: () => answerQuestion(index),
                      child: Text(
                        question.options[index],
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
