import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:superheroes/model/biography.dart';
import 'package:superheroes/model/powerstats.dart';
import 'package:superheroes/model/server_image.dart';
import 'package:superheroes/model/superhero.dart';
import 'package:superheroes/resources/superheroes_color.dart';
import 'package:superheroes/widgets/action_button.dart';

class SuperheroPage extends StatelessWidget {
  final String id;
  const SuperheroPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final superhero = Superhero(
        name: 'Batman',
        biography: Biography(
            fullName: 'Bruce Wayne',
            alignment: 'good',
            aliases: ['Insider', 'Matches Malone'],
            placeOfBirth: '"Crest Hill, Bristol Township; Gotham County'),
        image: ServerImage(
            'https://www.superherodb.com/pictures2/portraits/10/100/639.jpg'),
        powerstats: Powerstats(
            intelligence: '100',
            strength: '26',
            speed: '27',
            durability: '50',
            power: '47',
            combat: '100'),
        id: id);
    return Scaffold(
      backgroundColor: SuperHeroesColor.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            stretch: true,
            pinned: true,
            floating: true,
            expandedHeight: 348,
            backgroundColor: SuperHeroesColor.background,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                superhero.biography.fullName,
                style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: SuperHeroesColor.whiteText,
                    fontSize: 22),
              ),
              centerTitle: true,
              titlePadding: const EdgeInsets.only(left: 20, right: 20),
              background: CachedNetworkImage(
                imageUrl: superhero.image.url,
                fit: BoxFit.cover,
              ),
            ),
            centerTitle: true,
          ),
        ],
      ),
    );
  }
}
