/*
 * This Source Code Form is subject to the terms of the Mozilla Public 
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 */

part of libmahjonki;

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

class WallOutOfTilesExceptions implements Exception {
  WallOutOfTilesExceptions();
  String toString() {
    return "The wall has ran out of tiles to deal";
  }
}