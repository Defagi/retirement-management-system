// ignore_for_file: prefer_interpolation_to_compose_strings, library_private_types_in_public_api, use_key_in_widget_constructors, file_names, prefer_final_fields, prefer_const_constructors

import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController _messageController = TextEditingController();
  List<String> messages = [];

  void _updateChat(String messageContent) {
    setState(() {
      messages.add("You: $messageContent");
      String answer = generateAnswer(messageContent);
      messages.add("Bot: $answer");
    });
  }
  String generateAnswer(String question) {
    String lowercaseQuestion = question.toLowerCase();
    if (lowercaseQuestion.contains("hello") ||
        lowercaseQuestion.contains("hi") ||
        lowercaseQuestion.contains("what's your name")) {
      return "Hello! I'm your Retirement Management Assistant.";
    }
    if (lowercaseQuestion.contains("manage stress") ||
        lowercaseQuestion.contains("reduce stress") ||
        lowercaseQuestion.contains("cope with stress")) {
      return "Managing stress is essential for overall well-being. You can try techniques like deep breathing, meditation, exercise, spending time in nature, or talking to a friend or therapist.";
    }
    if (lowercaseQuestion.contains("feel anxious") ||
        lowercaseQuestion.contains("deal with anxiety")) {
      return "If you're feeling anxious, try grounding exercises, such as focusing on your breath or surroundings. Engaging in relaxing activities and avoiding caffeine and stressors can also be helpful.";
    }
    if (lowercaseQuestion.contains("cope with sadness") ||
        lowercaseQuestion.contains("deal with sadness")) {
      return "Coping with sadness involves acknowledging your feelings, talking to someone you trust, engaging in activities you enjoy, and seeking professional help if needed.";
    }
    switch (lowercaseQuestion) {
      case "how can i save more money?":
        return "There are various ways to save more money, such as creating a budget, cutting unnecessary expenses, and setting up automatic savings.";
      case "what are some good investment options?":
        return "Good investment options include stocks, bonds, mutual funds, real estate, and retirement accounts like 401(k)s and IRAs.";
      case "how to create a budget?":
        return "To create a budget, start by tracking your expenses, categorize them, set financial goals, and allocate your income accordingly.";
      case "what is the best way to pay off debt?":
        return "The best way to pay off debt is by using the debt snowball or debt avalanche method, where you prioritize paying off the highest interest debt or the smallest balance first.";
      case "how to start an emergency fund?":
        return "To start an emergency fund, set aside a portion of your income regularly into a separate savings account to cover unexpected expenses.";
      case "where can i get a personal loan?":
        return "You can get a personal loan from banks, credit unions, online lenders, or other financial institutions.";
      case "what are the benefits of a good credit score?":
        return "Having a good credit score can help you get approved for loans, credit cards, and lower interest rates, saving you money in the long run.";
      case "how to negotiate a salary increase?":
        return "To negotiate a salary increase, research salary ranges for your position, showcase your achievements, and be confident during the negotiation.";
      case "what is the right time to start investing?":
        return "The right time to start investing is as early as possible. The power of compounding can significantly grow your wealth over time.";
      case "how to avoid overspending?":
        return "To avoid overspending, create a budget, use cash instead of credit cards, and only purchase items that align with your financial goals.";
      case "what are the best money-saving apps?":
        return "Some popular money-saving apps include Acorns, Mint, Honey, Rakuten, and Truebill.";
      case "what is a retirement plan?":
        return "A retirement plan is a financial strategy designed to help individuals save and invest money to provide income during retirement.";
      case "how much should i save for retirement?":
        return "The amount you should save for retirement depends on factors like your desired lifestyle, retirement age, and expected expenses. A financial advisor can help you create a personalized plan.";
      case "what are the different types of retirement accounts?":
        return "Common retirement accounts include 401(k)s, IRAs, Roth IRAs, and pension plans offered by employers.";
      case "how does a 401(k) plan work?":
        return "A 401(k) plan is an employer-sponsored retirement account. Employees contribute a portion of their salary to the plan, and employers may offer matching contributions.";
      case "what is an individual retirement account (ira)?":
        return "An Individual Retirement Account (IRA) is a personal retirement savings account that offers tax advantages for individuals.";
      case "what are the benefits of contributing to a retirement account?":
        return "Contributing to a retirement account provides tax advantages, allows your money to grow tax-deferred, and helps secure your financial future.";
      case "how to create a retirement income strategy?":
        return "Creating a retirement income strategy involves determining how much income you'll need in retirement, considering different income sources like Social Security, pensions, and investments.";
      case "what are some retirement investment strategies?":
        return "Retirement investment strategies may include diversifying your portfolio, considering risk tolerance, and balancing stocks and bonds.";
      case "when should i start planning for retirement?":
        return "It's best to start planning for retirement as early as possible. The earlier you start, the more time your investments have to grow.";
      case "how to calculate my retirement savings goal?":
        return "To calculate your retirement savings goal, consider your desired retirement lifestyle, estimated expenses, and the number of years you expect to be in retirement.";
      case "what is social security, and how does it work?":
        return "Social Security is a government program that provides financial benefits to retired individuals, disabled individuals, and survivors of deceased workers.";
      case "what are some common retirement planning mistakes to avoid?":
        return "Common retirement planning mistakes include not saving enough, taking on too much risk, and not accounting for inflation.";
      case "what are the best resources for retirement planning?":
        return "There are many resources for retirement planning, including financial advisors, online calculators, retirement planning books, and educational websites.";
      default:
        return "I'm sorry, I don't have information on that topic at the moment.";
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ask Us Anything'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _messageController,
              onSubmitted: (value) {
                String question = value.trim();
                if (question.isNotEmpty) {
                  _updateChat(question);
                  _messageController.clear();
                }
              },
              decoration: InputDecoration(
                hintText: "Type a message...",
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    String question = _messageController.text.trim();
                    if (question.isNotEmpty) {
                      _updateChat(question);
                      _messageController.clear();
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}