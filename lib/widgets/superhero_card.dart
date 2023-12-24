// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/resources/superheroes_color.dart';
import 'package:superheroes/resources/superheroes_images.dart';

class SuperheroCard extends StatelessWidget {
  final SuperheroInfo superheroInfo;
  final VoidCallback onTap;

  const SuperheroCard({
    super.key,
    required this.superheroInfo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: SuperHeroesColor.backgroundCard,
        ),
        clipBehavior: Clip.antiAlias,
        height: 70,
        child: Row(
          children: [
            Container(
              color: Colors.white24,
              width: 70,
              height: 70,
              child: CachedNetworkImage(
                imageUrl: superheroInfo.imageURL,
                height: 70,
                width: 70,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, progress) {
                  return Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: SuperHeroesColor.blue,
                        value: progress.progress,
                      ),
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return Center(
                    child: Image.asset(
                      SuperHeroesImages.unknown,
                      width: 20,
                      height: 62,
                    ),
                  );
                },
              ),
            ),
            // Image.network(
            //   superheroInfo.imageURL,
            //   height: 70,
            //   width: 70,
            //   fit: BoxFit.cover,
            //   errorBuilder: (BuildContext context, Object exception,
            //       StackTrace? stackTrace) {
            //     return const SizedBox(
            //       width: 70,
            //       height: 70,
            //     );
            //   },
            // ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    superheroInfo.name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: SuperHeroesColor.whiteText,
                    ),
                  ),
                  Text(
                    superheroInfo.realName,
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
