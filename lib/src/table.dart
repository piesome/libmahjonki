/*
 * This Source Code Form is subject to the terms of the Mozilla Public 
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 */

part of libmahjonki;

/**
 * Represents the playing table.
 */
class Table {
  List<Tile> wall;
  List<Tile> dead_wall;
  Tile dora_indicator;
  
  /**
   * Creates a new table with shuffled wall, dead_wall and dora_indicator.
   */
  Table() {
    wall = [];
    dead_wall = [];
    
    var suites = [TileSuite.CIRCLE, TileSuite.BAMBOO, TileSuite.CHARACTER];
    var values = [TileValue.ONE, TileValue.TWO, TileValue.THREE,
                  TileValue.FOUR, TileValue.FIVE, TileValue.SIX,
                  TileValue.SEVEN, TileValue.EIGHT, TileValue.NINE];

    // There are 4 duplicates of each tile
    for (num i = 0; i < 4; i++) {
      for (TileSuite ts in suites) {
        for (TileValue tv in values) {
          Tile t = new Tile(ts, tv);
          // If this is the last round, let's add the fifth tile as a dora.
          if (tv == TileValue.FIVE && i == 3) {
            t.addAttribute(TileAttribute.DORA);
          }
          wall.add(t);
        }
      }
      // Winds
      wall.add(new Tile(TileSuite.WIND, TileValue.EAST));
      wall.add(new Tile(TileSuite.WIND, TileValue.SOUTH));
      wall.add(new Tile(TileSuite.WIND, TileValue.WEST));
      wall.add(new Tile(TileSuite.WIND, TileValue.NORTH));
      // Dragons
      wall.add(new Tile(TileSuite.DRAGON, TileValue.WHITE));
      wall.add(new Tile(TileSuite.DRAGON, TileValue.GREEN));
      wall.add(new Tile(TileSuite.DRAGON, TileValue.RED));
    }
    // Shuffle, dat autotable
    this.shuffle();
    // Allocate a dead wall
    for (num i = 0; i < 14; i++) {
      dead_wall.add(wall.removeLast());
    }
    /*
     * So, for authenticity the dora indicator is the upper tile of the third
     * last pair of the dead wall. 
     * 0 | 2 | 4 | 6 |*8*| 10 | 12
     * 1 | 3 | 5 | 7 | 9 | 11 | 13
     */
    dora_indicator = dead_wall[8];
    num dora_value = dora_indicator.value.value + 1;
    // Dora indicator flips
    if (dora_indicator.value == TileValue.NINE) {
      dora_value = TileValue.ONE.value;
    } else if (dora_indicator.value == TileValue.NORTH) {
      dora_value = TileValue.EAST.value;
    } else if (dora_indicator.value == TileValue.RED) {
      dora_value = TileValue.WHITE.value;
    }

    for (Tile t in wall) {
      if (t.value.value == dora_value) {
        t.addAttribute(TileAttribute.DORA);
      }
    }
    for (Tile t in dead_wall) {
      if (t.value.value == dora_value) {
        t.addAttribute(TileAttribute.DORA);
      }
    }
  }
  
  /**
   * Shuffle the wall.
   */
  shuffle() {
    this.wall.shuffle();
  }
  
  /**
   * Get a tile from the wall.
   */
  Tile draw() {
    if (this.wall.length == 0) {
      throw new WallOutOfTilesExceptions();
    }
    return this.wall.removeAt(0);
  }
  
  int get length {
    return this.wall.length;
  }
}
