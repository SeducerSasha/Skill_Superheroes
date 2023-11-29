// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_color.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        //alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        //height: 36,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: SuperHeroesColor.blue),
        child: Text(text.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: SuperHeroesColor.whiteText)),
      ),
    );
  }
}
