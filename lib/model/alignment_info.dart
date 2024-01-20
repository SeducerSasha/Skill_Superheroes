import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_color.dart';

class AlignmentInfo {
  final String name;
  final Color color;

  const AlignmentInfo._(this.name, this.color);

  static const bad = AlignmentInfo._('bad', SuperHeroesColor.red);
  static const good = AlignmentInfo._('good', SuperHeroesColor.green);
  static const neutral = AlignmentInfo._('neutral', SuperHeroesColor.grey);

  static AlignmentInfo? fromAlignment(final String alignment) {
    switch (alignment) {
      case 'bad':
        return bad;
      case 'good':
        return good;
      case 'neutral':
        return neutral;
      default:
        return null;
    }

    // if (alignment == 'bad') {
    //   return bad;
    // } else if (alignment == 'good') {
    //   return good;
    // } else if (alignment == 'neutral') {
    //   return neutral;
    // }

    return null;
  }
}
