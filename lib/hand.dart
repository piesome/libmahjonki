import 'tile.dart';
import 'dart:collection';

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

  void operator[]=(int index, Tile value) {
    innerList[index] = value;
  }
  Tile operator [](int index) => innerList[index];
  
  void add(Tile value) => innerList.add(value);
  void addAll(Iterable<Tile> all) => innerList.addAll(all);
}