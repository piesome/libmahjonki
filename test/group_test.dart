import 'package:unittest/unittest.dart';
import 'package:libmahjonki/libmahjonki.dart';

void main() {
  group("Tilegroup:", () {
    test("can initialize a TileGroup", () {
      List<Tile> tiles = [new Tile(TileSuite.BAMBOO, TileValue.TWO),
                          new Tile(TileSuite.BAMBOO, TileValue.TWO),
                          new Tile(TileSuite.BAMBOO, TileValue.TWO)];
      expect(new TileGroup(tiles), anything);
    });
    test("Tilegroup can create a set", () {
      List<Tile> tiles = [new Tile(TileSuite.BAMBOO, TileValue.TWO),
                          new Tile(TileSuite.BAMBOO, TileValue.TWO),
                          new Tile(TileSuite.BAMBOO, TileValue.TWO)];
      expect(new TileGroup(tiles).type, equals(TileGroupType.SET));
    });
    test("Tilegroup can create a straight", () {
      List<Tile> tiles = [new Tile(TileSuite.BAMBOO, TileValue.ONE),
                          new Tile(TileSuite.BAMBOO, TileValue.TWO),
                          new Tile(TileSuite.BAMBOO, TileValue.THREE)];
      expect(new TileGroup(tiles).type, equals(TileGroupType.STRAIGHT));
    });
    group("Throws exception on", () {
      test("non-consecutive group", () {
        List<Tile> tiles = [new Tile(TileSuite.BAMBOO, TileValue.ONE),
                            new Tile(TileSuite.BAMBOO, TileValue.THREE),
                            new Tile(TileSuite.BAMBOO, TileValue.THREE)];
        expect(() => new TileGroup(tiles), throwsA(new isInstanceOf<ArgumentError>()));
      });
      test("lenght of one", () {
        List<Tile> tiles = [new Tile(TileSuite.BAMBOO, TileValue.ONE)];
        expect(() => new TileGroup(tiles), throwsA(new isInstanceOf<ArgumentError>()));
      });
      test("different suites", () {
        List<Tile> tiles = [new Tile(TileSuite.BAMBOO, TileValue.ONE),
                            new Tile(TileSuite.CHARACTER, TileValue.THREE),
                            new Tile(TileSuite.CIRCLE, TileValue.THREE)];
        expect(() => new TileGroup(tiles), throwsA(new isInstanceOf<ArgumentError>()));
      });
      test("different honors", () {
        List<Tile> tiles = [new Tile(TileSuite.DRAGON, TileValue.GREEN),
                            new Tile(TileSuite.DRAGON, TileValue.RED),
                            new Tile(TileSuite.DRAGON, TileValue.RED)];
        expect(() => new TileGroup(tiles), throwsA(new isInstanceOf<ArgumentError>()));
      });
    });
  });
}