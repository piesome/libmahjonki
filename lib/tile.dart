/*
 * This Source Code Form is subject to the terms of the Mozilla Public 
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 */

import "enum.dart";

/**
 * InvalidTileCombinationException documents itself. An invalid combination of
 * TileSuite and TileValue has been detected.
 */
class InvalidTileCombinationException implements Exception {
  final TileSuite suite;
  final TileValue value;
  InvalidTileCombinationException(this.suite, this.value);
  String toString() {
    return "Invalid TileSuite and TileValue combination $suite $value";
  }
}

/**
 * Since Dart doesn't have proper enums, this must do for the time
 * being.
 */
class TileSuite extends MetaEnum {
  static const PIN = const TileSuite._(0, "pinzu");
  static const SOU = const TileSuite._(1, "sōzu");
  static const MAN = const TileSuite._(2, "manzu");
  static const KAZEHAI = const TileSuite._(3, "kazehai");
  static const SANGENPAI = const TileSuite._(4, "sangenpai");

  const TileSuite._(value, name): super(value, name);
}

/**
 * All in the same class for now.
 */
class TileValue extends MetaEnum {
  static const I = const TileValue._(1, "Ī");
  static const RYAN = const TileValue._(2, "Ryan");
  static const SAN = const TileValue._(3, "San");
  static const SU = const TileValue._(4, "Sū");
  static const U = const TileValue._(5, "Ū");
  static const RYU = const TileValue._(6, "Ryū");
  static const CHI = const TileValue._(7, "Chī");
  static const PA = const TileValue._(8, "Pā");
  static const CHU = const TileValue._(9, "Chū");

  static const TON = const TileValue._(10, "Ton");
  static const NAN = const TileValue._(11, "Nan");
  static const SHA = const TileValue._(12, "Shā");
  static const PEI = const TileValue._(13, "Pei");

  static const HAKU = const TileValue._(20, "Haku");
  static const HATSU = const TileValue._(21, "Hatsu");
  static const CHUN = const TileValue._(22, "Chun");

  const TileValue._(value, name): super(value, name);
}

/**
 * Tile attributes, like doras and terminals.
 */
class TileAttribute extends MetaEnum {
  static const DORA = const TileAttribute._(0, "Dora");
  static const TERMINAL = const TileAttribute._(1, "Terminal");
  static const GREEN = const TileAttribute._(2, "Green");

  const TileAttribute._(value, name): super(value, name);
}

/**
 * Represents a single tile.
 */
class Tile {
  final TileSuite suite;
  final TileValue value;
  num sort_index;
  List<TileAttribute> attributes;

  Tile(this.suite, this.value) {
    if (this.suite <= TileSuite.MAN) {
      if (this.value < TileValue.I || this.value > TileValue.CHU) {
        throw new InvalidTileCombinationException(this.suite, this.value);
      }
    } else if (this.suite == TileSuite.KAZEHAI) {
      if (this.value < TileValue.TON || this.value > TileValue.PEI) {
        throw new InvalidTileCombinationException(this.suite, this.value);
      }
    } else if (this.suite == TileSuite.SANGENPAI) {
      if (this.value < TileValue.HAKU || this.value > TileValue.CHUN) {
        throw new InvalidTileCombinationException(this.suite, this.value);
      }
    }

    this.attributes = [];

    if (this.value == TileValue.I || this.value == TileValue.CHU) {
      this.attributes.add(TileAttribute.TERMINAL);
    }
    if (this.value == TileValue.HATSU) {
      this.attributes.add(TileAttribute.GREEN);
    }
    if (this.suite == TileSuite.SOU) {
      if (this.value.value >= 2 && this.value.value <= 4) {
        this.attributes.add(TileAttribute.GREEN);
      } else if (this.value.value == 6 || this.value.value == 8) {
        this.attributes.add(TileAttribute.GREEN);
      }
    }

    this.sort_index = this.suite.value * 100 + this.value.value;
  }

  /// Does this tile have a spesific attribute?
  bool hasAttribute(TileAttribute attr) {
    for (TileAttribute at in this.attributes) {
      if (at == attr) {
        return true;
      }
    }
    return false;
  }

  String toString() {
    return "$value $suite $attributes";
  }

  bool operator ==(other) {
    if (other is! Tile) {
      return false;
    }
    return other.sort_index == this.sort_index;
  }

  bool operator >(other) {
    if (other is! Tile) {
      return false;
    }
    return this.sort_index > other.sort_index;
  }

  bool operator <(other) {
    if (other is! Tile) {
      return false;
    }
    return this.sort_index < other.sort_index;
  }

  bool operator >=(other) {
    if (other is! Tile) {
      return false;
    }
    return this.sort_index >= other.sort_index;
  }

  bool operator <=(other) {
    if (other is! Tile) {
      return false;
    }
    return this.sort_index <= other.sort_index;
  }

}
