// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_color.dart';

class SuperheroCard extends StatelessWidget {
  final String name;
  final String realName;
  final String imageUrl;
  final VoidCallback onTap;

  const SuperheroCard({
    super.key,
    required this.name,
    required this.realName,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        color: SuperHeroesColor.backgroundCard,
        child: Row(
          children: [
            Image.network(imageUrl, height: 70, width: 70, fit: BoxFit.cover),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: SuperHeroesColor.whiteText,
                    ),
                  ),
                  Text(
                    realName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: SuperHeroesColor.whiteText,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
