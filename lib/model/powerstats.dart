// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'powerstats.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab, explicitToJson: true)
class Powerstats {
  final String intelligence;
  final String strength;
  final String speed;
  final String durability;
  final String power;
  final String combat;

  Powerstats(
      {required this.intelligence,
      required this.strength,
      required this.speed,
      required this.durability,
      required this.power,
      required this.combat});

  bool inNotNull() {
    return intelligence != 'null' &&
        strength != 'null' &&
        speed != 'null' &&
        durability != 'null' &&
        power != 'null' &&
        combat != 'null';
  }

  double get intelligencePercent => valueToDouble(intelligence);
  double get strengthPercent => valueToDouble(strength);
  double get speedPercent => valueToDouble(speed);
  double get durabilityPercent => valueToDouble(durability);
  double get powerPercent => valueToDouble(power);
  double get combatPercent => valueToDouble(combat);

  double valueToDouble(final String value) {
    final valueParse = int.tryParse(value);
    if (valueParse == null) return 0;
    return valueParse / 100;
  }

  factory Powerstats.fromJson(final Map<String, dynamic> json) =>
      _$PowerstatsFromJson(json);

  Map<String, dynamic> toJson() => _$PowerstatsToJson(this);

  @override
  String toString() {
    return 'Powerstats({intelligence : $intelligence, strength: $strength, speed :$speed, durability: $durability, power: $power, combat: $combat})';
  }

  @override
  bool operator ==(covariant Powerstats other) {
    if (identical(this, other)) return true;

    return other.intelligence == intelligence &&
        other.strength == strength &&
        other.speed == speed &&
        other.durability == durability &&
        other.power == power &&
        other.combat == combat;
  }

  @override
  int get hashCode {
    return intelligence.hashCode ^
        strength.hashCode ^
        speed.hashCode ^
        durability.hashCode ^
        power.hashCode ^
        combat.hashCode;
  }
}
