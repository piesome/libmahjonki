/*
 * This Source Code Form is subject to the terms of the Mozilla Public 
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 */

part of libmahjonki;

/* point counter */

void _recurse(List<Tile> tiles, List<HandTileGroup> hands,
    PartialTileGroup current, PartialHandTileGroup hand) {
  Set<Tile> queue = Set.from(tiles);
  for (Tile t in queue) {
   switch (current.append(t)) {
     case 0:
       tiles.remove(t);
       _recurse(tiles, hands, current, hand);
       tiles.add(t);
       continue;
     case 1:
       if(hand.append(current)) {
         hands.append(hand);
         return hands;
       }
       tiles.remove(t);
       _recurse(tiles, hands, current, hand);
       tiles.add(t);
       continue;
     case -1:
       return;
   }
  }
}

List<HandTileGroup> _form_hands(List<Tile> tiles) {
  List<HandTileGroup> ret;
  for(Tile t in tiles) {
    List<Tile> current = List.from(tiles);
    current.remove(t);
    if(current.contains(t)) {
      List<Tile> pair = [t, t];
      current.remove(t);
      /* recursive backtracking bruteforce, max recurse 12 deep */
      _recurse(current, ret, PartialTileGroup(TileGroup(pair)), PartialHandTileGroup());
    }
  }
  return ret;
}

void count_points(Hand hand) {
  
}