/*
 * This Source Code Form is subject to the terms of the Mozilla Public 
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 */

part of libmahjonki;

/* Build a tile from a two-character string:
 * Pin=P, Sou=S, Man=M, Dragon=D, Wind=W,
 * Red,Green,White=RGW, East,South,West,North=ESWN,
 * example: P1 = Pin 1, DW = White Dragon */
Tile get_tile(String str) {
  TileSuite suite;
  TileValue value;
  switch(str[0]) {
 }
  value = string_to_tilevalue(str[1]);
}

TileSuite string_to_tilesuite(String str) {
  switch(str) {
    case "P":
      return TileSuite.PIN;
    case "S":
      return TileSuite.SOU;
    case "M":
      return TileSuite.MAN;
    case "J":
      return TileSuite.JIHAI;
    default:
      throw new ArgumentError("Invalid value for converting suite to tilesuite (" + str + ")");
  }
}

TileValue string_to_tilevalue(String str) {
  switch(str) {
    case "1":
      return TileValue.ONE;
    case "2":
      return TileValue.TWO;
    case "3":
      return TileValue.THREE;
    case "4":
      return TileValue.FOUR;
    case "5":
      return TileValue.FIVE;
    case "6":
      return TileValue.SIX;
    case "7":
      return TileValue.SEVEN;
    case "8":
      return TileValue.EIGHT;
    case "9":
      return TileValue.NINE;
    case "":
      return TileValue.NINE;
    default:
      throw new ArgumentError("Invalid value for converting number to tilevalue (" + str + ")");
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
  static const JIHAI = const TileSuite._(3, "jihai");
  
  // Aliases for us noobs.
  static const CIRCLE    = PIN;
  static const BAMBOO    = SOU;
  static const CHARACTER = MAN;
  static const HONOR     = JIHAI;

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
  
  // Aliases for us noobs.
  static const ONE   = I;
  static const TWO   = RYAN;
  static const THREE = SAN;
  static const FOUR  = SU;
  static const FIVE  = U;
  static const SIX   = RYU;
  static const SEVEN = CHI;
  static const EIGHT = PA;
  static const NINE  = CHU;
  
  static const EAST  = TON;
  static const SOUTH = NAN;
  static const WEST  = SHA;
  static const NORTH = PEI;
  
  static const WHITE = HAKU;
  static const GREEN = HATSU;
  static const RED   = CHUN;

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
class Tile implements Comparable<Tile> {
  final TileSuite suite;
  final TileValue value;
  num sort_index;
  List<TileAttribute> attributes;

  Tile(this.suite, this.value) {
    if (this.suite <= TileSuite.MAN) {
      if (this.value < TileValue.I || this.value > TileValue.CHU) {
        throw new InvalidTileCombinationException(this.suite, this.value);
      }
    } else if (this.suite == TileSuite.JIHAI) {
      if (this.value < TileValue.TON || this.value > TileValue.CHUN) {
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
  
  addAttribute(TileAttribute attr) {
    this.attributes.add(attr);
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

  @override
  int compareTo(Tile other) {
    if (this < other)
      return -1;
    else if(this > other)
      return 1;
    return 0;
  }
}
