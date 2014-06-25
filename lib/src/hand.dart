/*
 * This Source Code Form is subject to the terms of the Mozilla Public 
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 */

part of libmahjonki;

/**
 * Hand wraps a list inside.
 * 
 * http://stackoverflow.com/questions/16247045/how-do-i-extend-a-list-in-dart
 */
class Hand<Tile> extends ListBase<Tile> {
  List<Tile> innerList = new List();

  int get length => innerList.length;
  void set length(int length) {
    innerList.length = length;
  }

  void operator []=(int index, Tile value) {
    innerList[index] = value;
  }
  Tile operator [](int index) => innerList[index];

  void add(Tile value) => innerList.add(value);
  void addAll(Iterable<Tile> all) => innerList.addAll(all);
}
