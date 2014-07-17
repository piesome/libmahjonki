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
  static const YAOCHUUHAI = const TileGroupAttribute ._(2, "")
  
  const TileGroupAttribute ._(value, name): super(value, name);
}

class TileGroup {
  List<Tile> content;
  TileGroupType type;
  List<TileGroupAttribute> attributes;
  
  TileGroup(List<Tile> content) {
    content.sort();
    attributes = new List<TileGroupAttribute>();
    if(content.length < 2 || content.length > 4)
      throw new ArgumentError("Tried to create a set of invalid length!");
    if(content.length == 2) {
      if(content[0] != content[1])
        throw new ArgumentError("Tried to get an invalid set!");
      if(content[0].suite == TileSuite.JIHAI) {
        this.attributes.add(TileGroupAttribute.HONOR);
        this.attributes.add(TileGroupAttribute.TERMINAL);
      }
      else if(content[0].value.value == 1 || content[0].value.value == 9)
        this.attributes.add(TileGroupAttribute.TERMINAL);
      this.type = TileGroupType.ATAMA;
    }
    else if(content[0] != content[1]) {
      if(content[0] > 7) {
        throw new ArgumentError("Tried to get an invalid set!");
      }
      if(content[0].value.value +1 != content[1].value.value || content[1].value.value + 1 != content[2].value.value) {
        throw new ArgumentError("Tried to get an invalid set!");
      }
      if(content[0].value.value == 1 || content[0].value.value == 7)
        this.attributes.add(TileGroupAttribute.TERMINAL);
      this.type = TileGroupType.SHUNTSU;
    }
    else {
      Tile t = content[0];
      bool terminal = true;
      bool honor = true;
      for(Tile tile in content) {
        if(t != tile) {
          throw new ArgumentError("Tried to get an invalid set!");
        }
        if(t.suite != TileSuite.JIHAI) {
          honor = false;
          if(t.value != 1 && t.value != 9)
            terminal = false;
        }
      }
      if(terminal) this.attributes.add(TileGroupAttribute.TERMINAL);
      if(honor) this.attributes.add(TileGroupAttribute.HONOR);
      this.type = TileGroupType.KOUTSU;
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
      throw new ArgumentError("Tried to form an invalid hand!");
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
  List<Tile> can_complete;
  PartialTileGroup() {
    tiles = new List<Tile>();
    can_complete = new List<Tile>();
  }
  /* return: 0 on partial, -1 on error, 1 on full
   * not in try-catch for performance reasons
   * (called tons of times in tight loop) */ 
  int add(Tile t) {
    switch (tiles.length){
      case 0:
        tiles.add(t);
        return 0;
      case 1:
        if (t.suite != tiles[0].suite) {
          /* not same suite, invalid set */
          return -1;
        }
        if(t.value == tiles[0]) {
          tiles.add(t);
          can_complete.add(t);
          return 0;
        }
        if (t.suite == TileSuite.JIHAI) {
          /* honor set, not equal */
          return -1;
        }
        int difference = (t.value.value - tiles[0].value.value).abs();
        if (difference < 3) {
          tiles.add(t);
          tiles.sort();
          int val = tiles[0].value.value;
          if (difference == 1) {
            /* okay then, too late to think a good way */
            if (val == 2)
              can_complete.add(new Tile(t.suite, TileValue.ONE));
            if (val == 3)
              can_complete.add(new Tile(t.suite, TileValue.TWO));
            if (val == 1 || val == 4)
              can_complete.add(new Tile(t.suite, TileValue.THREE));
            else if (val == 2 || val == 5)
              can_complete.add(new Tile(t.suite, TileValue.FOUR));
            else if (val == 3 || val == 6)
              can_complete.add(new Tile(t.suite, TileValue.FIVE));
            if (val == 4 || val == 7)
              can_complete.add(new Tile(t.suite, TileValue.SIX));
            else if (val == 5 || val == 8)
              can_complete.add(new Tile(t.suite, TileValue.SEVEN));
            else if (val == 6 || val == 9)
              can_complete.add(new Tile(t.suite, TileValue.EIGHT));
            else if (val == 7) /* actually always true at this point */
              can_complete.add(new Tile(t.suite, TileValue.NINE));
            return 0;
          }
          else {
            if (val == 1)
              can_complete.add(new Tile(t.suite, TileValue.TWO));
            if (val == 2)
              can_complete.add(new Tile(t.suite, TileValue.THREE));
            else if (val == 3)
              can_complete.add(new Tile(t.suite, TileValue.FOUR));
            else if (val == 4)
              can_complete.add(new Tile(t.suite, TileValue.FIVE));
            if (val == 5)
              can_complete.add(new Tile(t.suite, TileValue.SIX));
            else if (val == 6)
              can_complete.add(new Tile(t.suite, TileValue.SEVEN));
            else if (val == 7)
              can_complete.add(new Tile(t.suite, TileValue.EIGHT));
            return 0;
          }
        }
        return -1;
      case 2:
        if (can_complete.contains(t)) {
          tiles.add(t);
          /* hooray */
          return 1;
        }
        return -1;
    }
    throw "Tried to append too much!";
  }
  /* returns true if cannot backtrack */
  bool backtrack() {
    if(tiles.length == 0)
      return true;
    tiles.removeLast();
    can_complete.clear();
    return false;
  }
}

class PartialHandTileGroup {
  List<TileGroup> groups;
  
  PartialHandTileGroup(TileGroup pair) {
    groups = new List<TileGroup>();
    if(pair.type != TileGroupType.ATAMA)
      throw "Must initialize PartialHandTileGroup with a pair!";
    this.groups.add(pair);
  }
  void add(TileGroup group) {
    if (groups.length > 1) {
      if (group.type == TileGroupType.ATAMA && groups[1].type != TileGroupType.ATAMA)
        throw "Cannot complete a normal hand with a pair!";
      else if (group.type != TileGroupType.ATAMA && groups[1].type == TileGroupType.ATAMA)
        throw "Cannot complete a chiitoi with a normal group!";
    }
    groups.add(group);
  }
  bool hasType(TileGroupType type) {
    for(TileGroup group in this.groups) {
      if(group.type == type)
        return true;
    }
    return false;
  }
}