import 'package:libmahjonki/libmahjonki.dart';

void main() {
  Table t = new Table();
  while(true) {
    try {
      print(t.draw());
    } catch (WallOutOfTilesException) {
      return;
    }
  }
}
