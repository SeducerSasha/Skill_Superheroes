import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_color.dart';
import 'package:superheroes/widgets/action_button.dart';

class SuperheroPage extends StatelessWidget {
  final String name;
  const SuperheroPage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SuperHeroesColor.background,
      body: SafeArea(
          child: Stack(
        children: [
          Center(
              child: Text(
            name,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: SuperHeroesColor.whiteText),
          )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: ActionButton(
                  text: 'Back',
                  onTap: () {
                    Navigator.of(context).pop();
                  }),
            ),
          )
        ],
      )),
    );
  }
}
