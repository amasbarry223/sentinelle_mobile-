import 'package:flutter/material.dart';

class ScamGuide {
  final String id;
  final String title;
  final String summary;
  final IconData icon;
  final String howItWorks;
  final String exampleSender;
  final String exampleMessage;
  final List<String> warningSigns;
  final List<String> whatToDo;
  final String bambaraSummary;

  const ScamGuide({
    required this.id,
    required this.title,
    required this.summary,
    required this.icon,
    required this.howItWorks,
    required this.exampleSender,
    required this.exampleMessage,
    required this.warningSigns,
    required this.whatToDo,
    required this.bambaraSummary,
  });
}
