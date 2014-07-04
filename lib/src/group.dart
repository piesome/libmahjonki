/*
 * This Source Code Form is subject to the terms of the Mozilla Public 
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 */

part of libmahjonki;

/* groups of Tiles */

class TileGroupType extends MetaEnum {
  static const ATAMA = const TileGroupType._(0, "atama");
  static const PAIR = ATAMA;
  static const KOUTSU = const TileGroupType._(1, "koutsu");
  static const SET = KOUTSU;
  static const SHUNTSU = const TileGroupType._(2, "shuntsu");
  static const STRAIGHT = SHUNTSU;
  const TileGroupType._(value, name): super(value, name);
}
class TileGroupAttribute extends MetaEnum {
  static const TERMINAL = const TileGroupAttribute ._(0, "terminal");
  static const HONOR = const TileGroupAttribute ._(1, "honor");
  
  const TileGroupAttribute ._(value, name): super(value, name);
}

class TileGroup {
  List<Tile> content;
  TileGroupType type;
  List<TileGroupAttribute> attributes;
  
  TileGroup(List<Tile> content) {
    content.sort();
    if(content.length < 2 || content.length > 4)
      throw "Tried to create a set of invalid length!";
    if(content.length == 2) {
      if(content[0] != content[1])
        throw "Tried to get an invalid set!";
      if(content[0].suite == TileSuite.KAZEHAI || content[0].suite == TileSuite.SANGENPAI)
        this.attributes.add(TileGroupAttribute.HONOR);
      else if(content[0].value == 1 || content[0].value == 9)
        this.attributes.add(TileGroupAttribute.TERMINAL);
      this.type = TileGroupType.ATAMA;
    }
    else if(content[0] != content[1]) {
      if(content[0] > 7) {
        throw "Tried to get an invalid set!";
      }
      if(content[0].value.value +1 != content[1].value.value || content[1].value.value + 1 != content[2].value.value) {
        throw "Tried to get an invalid set!";
      }
      if(content[0] == 7)
        this.attributes.add(TileGroupAttribute.TERMINAL);
      this.type = TileGroupType.SHUNTSU;
    }
    else {
      Tile t = content[0];
      bool terminal = true;
      bool honor = true;
      for(Tile tile in content) {
        if(t != tile) {
          throw "Tried to get an invalid set!";
        }
        if(t.suite != TileSuite.KAZEHAI && t.suite != TileSuite.SANGENPAI) {
          honor = false;
          if(t.value != 1 && t.value != 9)
            terminal = false;
        }
      }
      if(terminal) this.attributes.add(TileGroupAttribute.TERMINAL);
      if(honor) this.attributes.add(TileGroupAttribute.HONOR);
    }
    this.content = content;
  }
  
  bool hasAttribute(TileGroupAttribute attribute) {
    for (TileGroupAttribute attr in this.attributes) {
      if (attr == attribute) {
        return true;
      }
    }
    return false;
  }
}

/* 5 (3-3-3-2) or 7 (7 pairs) groups of tiles that make a valid hand */
class HandTileGroup {
  List<TileGroup> groups;
  
  /* also called 7 pairs */
  bool chiitoitsu;
  
  HandTileGroup(List<TileGroup> groups) {
    this.chiitoitsu = true;
    for(TileGroup group in groups) {
      if(group.type != TileGroupType.ATAMA) {
        this.chiitoitsu = false;
        break;
      }
    }
    if((chiitoitsu && groups.length != 7) || groups.length != 4)
      throw "Tried to form an invalid hand!";
  }
  
  bool hasAttribute(TileGroupAttribute attribute) {
    for (TileGroup group in this.groups) {
      if (!group.hasAttribute(attribute)) {
        return false;
      }
    }
    return true;
  }
  
  int countType(TileGroupType type) {
    int ret = 0;
    for (TileGroup group in this.groups) {
      if (group.type == type) {
        ret += 1;
      }
    }
    return ret;
  }
}

class PartialTileGroup {
  List<Tile> tiles;
  PartialTileGroup(Tile tile) {
    tiles.add(tile);
  }
  bool append(Tile tile) {
    
    tiles.add(tile);
    return true;
  }
}

class PartialHandTileGroup {
  List<TileGroup> groups;
  
  PartialHandTileGroup(TileGroup pair) {
    if(pair.type != TileGroupType.ATAMA)
      throw "Must initialize PartialHandTileGroup with a pair!";
    this.groups.add(pair);
  }
  bool append(TileGroup group) {
    if(group.type == TileGroupType.ATAMA && this.hasType(TileGroupType.KOUTSU) || this.hasType(TileGroupType.SHUNTSU))
      return false;
    groups.add(group);
    return true;
  }
  bool hasType(TileGroupType type) {
    for(TileGroup group in this.groups) {
      if(group.type == type)
        return true;
    }
    return false;
  }
}