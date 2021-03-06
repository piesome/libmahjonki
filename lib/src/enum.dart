/*
 * This Source Code Form is subject to the terms of the Mozilla Public 
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 */

part of libmahjonki;

/**
 * It's kind of like a enum. Kinda.
 */
class MetaEnum implements Comparable<MetaEnum> {
  final int value;
  final String name;

  const MetaEnum(this.value, this.name);

  String toString() {
    return "$name ($value)";
  }

  bool operator ==(other) {
    if (other is! MetaEnum) {
      return false;
    }
    if (other.value != this.value) {
      return false;
    }
    if (other.name != this.name) {
      return false;
    }
    return true;
  }

  bool operator >(other) {
    if (other is! MetaEnum) {
      return false;
    }
    return this.value > other.value;
  }

  bool operator <(other) {
    if (other is! MetaEnum) {
      return false;
    }
    return this.value < other.value;
  }

  bool operator >=(other) {
    if (other is! MetaEnum) {
      return false;
    }
    return this.value >= other.value;
  }

  bool operator <=(other) {
    if (other is! MetaEnum) {
      return false;
    }
    return this.value <= other.value;
  }

  int compareTo(other) {
    return this == other ? 1 : 0;
  }
}
