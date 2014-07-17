import 'package:unittest/unittest.dart';
import 'package:libmahjonki/libmahjonki.dart';

void main() {
  group("Tilegroup", () {
    group("can initialize", () {
      test("", () {
        List<Tile> tiles = [new Tile(TileSuite.BAMBOO, TileValue.TWO),
                            new Tile(TileSuite.BAMBOO, TileValue.TWO),
                            new Tile(TileSuite.BAMBOO, TileValue.TWO)];
        expect(new TileGroup(tiles), anything);
      });
      test("a set", () {
        List<Tile> tiles = [new Tile(TileSuite.BAMBOO, TileValue.TWO),
                            new Tile(TileSuite.BAMBOO, TileValue.TWO),
                            new Tile(TileSuite.BAMBOO, TileValue.TWO)];
        expect(new TileGroup(tiles).type, equals(TileGroupType.SET));
      });
      test("a straight", () {
        List<Tile> tiles = [new Tile(TileSuite.BAMBOO, TileValue.ONE),
                            new Tile(TileSuite.BAMBOO, TileValue.TWO),
                            new Tile(TileSuite.BAMBOO, TileValue.THREE)];
        expect(new TileGroup(tiles).type, equals(TileGroupType.STRAIGHT));
      });
      test("a pair", () {
        List<Tile> tiles = [new Tile(TileSuite.BAMBOO, TileValue.ONE),
                            new Tile(TileSuite.BAMBOO, TileValue.ONE)];
        expect(new TileGroup(tiles).type, equals(TileGroupType.PAIR));
      });
    });
    group("throws exception on", () {
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
        List<Tile> tiles = [new Tile(TileSuite.HONOR, TileValue.GREEN),
                            new Tile(TileSuite.HONOR, TileValue.RED),
                            new Tile(TileSuite.HONOR, TileValue.RED)];
        expect(() => new TileGroup(tiles), throwsA(new isInstanceOf<ArgumentError>()));
      });
    });
    group("has attribute", () {
      test("no attributes", () {
        List<Tile> tiles = [new Tile(TileSuite.BAMBOO, TileValue.THREE),
                            new Tile(TileSuite.BAMBOO, TileValue.THREE),
                            new Tile(TileSuite.BAMBOO, TileValue.THREE)];
        expect(new TileGroup(tiles).attributes.length, equals(0));
      });
      test("no attributes on pair", () {
        List<Tile> tiles = [new Tile(TileSuite.BAMBOO, TileValue.THREE),
                            new Tile(TileSuite.BAMBOO, TileValue.THREE)];
        expect(new TileGroup(tiles).attributes.length, equals(0));
      });
      test("only terminal", () {
        List<Tile> tiles = [new Tile(TileSuite.BAMBOO, TileValue.ONE),
                            new Tile(TileSuite.BAMBOO, TileValue.TWO),
                            new Tile(TileSuite.BAMBOO, TileValue.THREE)];
        expect(new TileGroup(tiles).attributes.length, equals(1));;
        expect(new TileGroup(tiles).hasAttribute(TileGroupAttribute.TERMINAL), isTrue);
      });
      test("only terminal on pair", () {
        List<Tile> tiles = [new Tile(TileSuite.BAMBOO, TileValue.ONE),
                            new Tile(TileSuite.BAMBOO, TileValue.ONE)];
        expect(new TileGroup(tiles).attributes.length, equals(1));;
        expect(new TileGroup(tiles).hasAttribute(TileGroupAttribute.TERMINAL), isTrue);
      });
      test("terminal and honor on dragons", () {
        List<Tile> tiles = [new Tile(TileSuite.HONOR, TileValue.GREEN),
                            new Tile(TileSuite.HONOR, TileValue.GREEN),
                            new Tile(TileSuite.HONOR, TileValue.GREEN)];
        expect(new TileGroup(tiles).attributes.length, equals(2));
        expect(new TileGroup(tiles).hasAttribute(TileGroupAttribute.TERMINAL), isTrue);
        expect(new TileGroup(tiles).hasAttribute(TileGroupAttribute.HONOR), isTrue);
      });
      test("terminal and honor on pair of dragons", () {
        List<Tile> tiles = [new Tile(TileSuite.HONOR, TileValue.GREEN),
                            new Tile(TileSuite.HONOR, TileValue.GREEN)];
        expect(new TileGroup(tiles).attributes.length, equals(2));
        expect(new TileGroup(tiles).hasAttribute(TileGroupAttribute.TERMINAL), isTrue);
        expect(new TileGroup(tiles).hasAttribute(TileGroupAttribute.HONOR), isTrue);
      });
      test("terminal and honor on winds", () {
        List<Tile> tiles = [new Tile(TileSuite.HONOR, TileValue.EAST),
                            new Tile(TileSuite.HONOR, TileValue.EAST),
                            new Tile(TileSuite.HONOR, TileValue.EAST)];
        expect(new TileGroup(tiles).attributes.length, equals(2));
        expect(new TileGroup(tiles).hasAttribute(TileGroupAttribute.TERMINAL), isTrue);
        expect(new TileGroup(tiles).hasAttribute(TileGroupAttribute.HONOR), isTrue);
      });
      test("terminal and honor on pair of winds", () {
        List<Tile> tiles = [new Tile(TileSuite.HONOR, TileValue.EAST),
                            new Tile(TileSuite.HONOR, TileValue.EAST)];
        expect(new TileGroup(tiles).attributes.length, equals(2));
        expect(new TileGroup(tiles).hasAttribute(TileGroupAttribute.TERMINAL), isTrue);
        expect(new TileGroup(tiles).hasAttribute(TileGroupAttribute.HONOR), isTrue);
      });
    });
  });
  group("PartialTilegroup", () {
    test("can initialize", () {
      expect(new PartialTileGroup(), anything);
    });
    group("can append", () {
      test("to empty", () {
        PartialTileGroup group = new PartialTileGroup();
        group.add(new Tile(TileSuite.BAMBOO, TileValue.TWO));
      });      
    });
  });
}