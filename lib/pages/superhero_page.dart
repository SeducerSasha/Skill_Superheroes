import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/superhero_bloc.dart';

import 'package:superheroes/model/biography.dart';
import 'package:superheroes/model/powerstats.dart';

import 'package:superheroes/model/superhero.dart';
import 'package:superheroes/resources/superheroes_color.dart';
import 'package:superheroes/resources/superheroes_icons.dart';
import 'package:superheroes/resources/superheroes_images.dart';

class SuperheroPage extends StatefulWidget {
  final http.Client? client;
  final String id;
  const SuperheroPage({super.key, this.client, required this.id});

  @override
  State<SuperheroPage> createState() => _SuperheroPageState();
}

class _SuperheroPageState extends State<SuperheroPage> {
  late SuperheroBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = SuperheroBloc(client: widget.client, id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: bloc,
      child: const Scaffold(
        backgroundColor: SuperHeroesColor.background,
        body: SuperheroContentPage(),
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

class SuperheroContentPage extends StatelessWidget {
  const SuperheroContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SuperheroBloc>(context, listen: false);

    return StreamBuilder<Superhero>(
        stream: bloc.observeSuperHero(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox.shrink();
          }
          final superhero = snapshot.data!;
          return CustomScrollView(
            slivers: [
              SuperHeroAppBar(superhero: superhero),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    if (superhero.powerstats.inNotNull())
                      PoretstatsWidget(
                        powerstats: superhero.powerstats,
                      ),
                    BiographyWidget(biography: superhero.biography),
                  ],
                ),
              ),
            ],
          );
        });
  }
}

class SuperHeroAppBar extends StatelessWidget {
  const SuperHeroAppBar({
    super.key,
    required this.superhero,
  });

  final Superhero superhero;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      stretch: true,
      pinned: true,
      floating: true,
      expandedHeight: 348,
      backgroundColor: SuperHeroesColor.background,
      foregroundColor: SuperHeroesColor.whiteText,
      actions: const [
        FavoriteButton(),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          superhero.biography.fullName,
          textAlign: TextAlign.center,
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
          placeholder: (context, url) {
            return Container(
              color: SuperHeroesColor.background75,
              child: const SizedBox(
                height: 348,
                width: 360,
              ),
            );
          },
          errorWidget: (context, url, error) {
            return Container(
              color: SuperHeroesColor.background75,
              child: Center(
                child: Image.asset(
                  SuperHeroesImages.unknown,
                  width: 85,
                  height: 264,
                ),
              ),
            );
          },
        ),
      ),
      centerTitle: true,
    );
  }
}

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SuperheroBloc>(context, listen: false);
    return StreamBuilder<bool>(
        stream: bloc.observeIsFavorites(),
        initialData: false,
        builder: (context, snapshot) {
          final favorite =
              !snapshot.hasData || snapshot.data == null || snapshot.data!;
          return GestureDetector(
            onTap: () =>
                favorite ? bloc.removeFromFavorites() : bloc.addToFavorites(),
            child: Container(
              height: 52,
              width: 52,
              alignment: Alignment.center,
              child: Image.asset(
                favorite
                    ? SuperHeroesIcons.starFilled
                    : SuperHeroesIcons.starEmpty,
                width: 32,
                height: 32,
              ),
            ),
          );
        });
  }
}

class PoretstatsWidget extends StatelessWidget {
  const PoretstatsWidget({super.key, required this.powerstats});

  final Powerstats powerstats;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Powerstats'.toUpperCase(),
          style: const TextStyle(
            color: SuperHeroesColor.whiteText,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Row(
          children: [
            const SizedBox(
              width: 16,
            ),
            Expanded(
                child: PowerStatWidget(
              powerstatname: 'intelligence',
              powerstatvalue: powerstats.intelligencePercent,
            )),
            Expanded(
                child: PowerStatWidget(
              powerstatname: 'strength',
              powerstatvalue: powerstats.strengthPercent,
            )),
            Expanded(
                child: PowerStatWidget(
              powerstatname: 'speed',
              powerstatvalue: powerstats.speedPercent,
            )),
            const SizedBox(
              width: 16,
            ),
          ],
        ),
        const SizedBox(
          height: 26,
        ),
        Row(
          children: [
            const SizedBox(
              width: 16,
            ),
            Expanded(
                child: PowerStatWidget(
              powerstatname: 'durability',
              powerstatvalue: powerstats.durabilityPercent,
            )),
            Expanded(
                child: PowerStatWidget(
              powerstatname: 'power',
              powerstatvalue: powerstats.powerPercent,
            )),
            Expanded(
                child: PowerStatWidget(
              powerstatname: 'combat',
              powerstatvalue: powerstats.combatPercent,
            )),
            const SizedBox(
              width: 16,
            ),
          ],
        ),
        const SizedBox(
          height: 36,
        ),
      ],
    );
  }
}

class PowerStatWidget extends StatelessWidget {
  const PowerStatWidget(
      {super.key, required this.powerstatname, required this.powerstatvalue});

  final String powerstatname;
  final double powerstatvalue;

  @override
  Widget build(BuildContext context) {
    Color colorPowerStat = const Color(0xFFF97236);

    if (powerstatvalue <= 0.5) {
      colorPowerStat =
          Color.lerp(Colors.red, Colors.orangeAccent, powerstatvalue / 0.5)!;
    } else {
      colorPowerStat = Color.lerp(
          Colors.orangeAccent, Colors.green, (powerstatvalue - 0.5) / 0.5)!;
    }

    return Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            const ArcWidget(value: 1, color: Colors.white24),
            ArcWidget(value: powerstatvalue, color: colorPowerStat),
            Padding(
              padding: const EdgeInsets.only(top: 17),
              child: Text(
                '${(powerstatvalue * 100).toInt()}',
                style: TextStyle(
                  color: colorPowerStat,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 44),
              child: Text(
                powerstatname.toUpperCase(),
                style: const TextStyle(
                  color: SuperHeroesColor.whiteText,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ArcWidget extends StatelessWidget {
  final double value;
  final Color color;

  const ArcWidget({super.key, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ArcCustomPainter(value: value, color: color),
      size: const Size(66, 33),
    );
  }
}

class ArcCustomPainter extends CustomPainter {
  final double value;
  final Color color;
  ArcCustomPainter({
    required this.value,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6;

    canvas.drawArc(rect, pi, pi * value, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is ArcCustomPainter) {
      return oldDelegate.value != value && oldDelegate.color != color;
    }

    return true;
  }
}

class BiographyWidget extends StatelessWidget {
  const BiographyWidget({super.key, required this.biography});

  final Biography biography;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: SuperHeroesColor.background75,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Bio'.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: SuperHeroesColor.whiteText,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
              ),
              BiographiInfoWidget(name: 'Full name', value: biography.fullName),
              BiographiInfoWidget(
                  name: 'Aliases', value: biography.aliases.join(',')),
              BiographiInfoWidget(
                  name: 'Place-of-birth', value: biography.placeOfBirth),
            ],
          ),
        ),
      ),
    );
  }
}

class BiographiInfoWidget extends StatelessWidget {
  final String name;
  final String value;
  const BiographiInfoWidget({
    super.key,
    required this.name,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name.toUpperCase(),
          textAlign: TextAlign.left,
          style: const TextStyle(
              color: SuperHeroesColor.grey,
              fontSize: 12,
              fontWeight: FontWeight.w600),
        ),
        Text(
          value,
          textAlign: TextAlign.left,
          style: const TextStyle(
              color: SuperHeroesColor.whiteText,
              fontSize: 16,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
