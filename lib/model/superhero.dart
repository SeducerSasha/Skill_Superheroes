// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:superheroes/model/biography.dart';
import 'package:superheroes/model/powerstats.dart';
import 'package:superheroes/model/server_image.dart';

part 'superhero.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab, explicitToJson: true)
class Superhero {
  final String name;
  final Biography biography;
  final ServerImage image;
  final Powerstats powerstats;
  final String id;

  Superhero(
      {required this.name,
      required this.biography,
      required this.image,
      required this.powerstats,
      required this.id});

  factory Superhero.fromJson(final Map<String, dynamic> json) =>
      _$SuperheroFromJson(json);

  Map<String, dynamic> toJson() => _$SuperheroToJson(this);

  @override
  String toString() {
    return 'Superhero({name : $name, biography: $biography, image :$image, powerstats: $powerstats, id: $id})';
  }

  @override
  bool operator ==(covariant Superhero other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.biography == biography &&
        other.image == image &&
        other.powerstats == powerstats &&
        other.id == id;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        biography.hashCode ^
        image.hashCode ^
        powerstats.hashCode ^
        id.hashCode;
  }
}
