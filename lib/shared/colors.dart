import 'package:flutter/material.dart';
import 'package:metaballs/metaballs.dart';
class ColorsEffectPair {
  final List<Color> colors;
  final MetaballsEffect? effect;
  final String name;

  ColorsEffectPair({
    required this.colors,
    required this.name,
    required this.effect,
  });
}

List<ColorsEffectPair> colorsAndEffects = [
  ColorsEffectPair(
      colors: [
     Colors.yellow,
        const Color.fromARGB(255, 255, 153, 0),
      ],
      effect: MetaballsEffect.follow(),
      name: 'FOLLOW'
  ),
 /* ColorsEffectPair(
      colors: [
        const Color.fromARGB(255, 0, 255, 106),
        const Color.fromARGB(255, 255, 251, 0),
      ],
      effect: MetaballsEffect.grow(),
      name: 'GROW'
  ),
  ColorsEffectPair(
      colors: [
        const Color.fromARGB(255, 90, 60, 255),
        const Color.fromARGB(255, 120, 255, 255),
      ],
      effect: MetaballsEffect.speedup(),
      name: 'SPEEDUP'
  ),
  ColorsEffectPair(
      colors: [
        const Color.fromARGB(255, 255, 60, 120),
        const Color.fromARGB(255, 237, 120, 255),
      ],
      effect: MetaballsEffect.ripple(),
      name: 'RIPPLE'
  ),
  ColorsEffectPair(
      colors: [
        const Color.fromARGB(255, 120, 217, 255),
        const Color.fromARGB(255, 255, 234, 214),
      ],
      effect: null,
      name: 'NONE'
  ),*/
];
