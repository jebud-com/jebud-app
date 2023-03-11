
import 'package:isar/isar.dart';

extension StringExt on String {
  int fastHash() {
    var hash = 0xcbf29ce484222325;

    var i = 0;
    while (i < length) {
      final codeUnit = codeUnitAt(i++);
      hash ^= codeUnit >> 8;
      hash *= 0x100000001b3;
      hash ^= codeUnit & 0xFF;
      hash *= 0x100000001b3;
    }

    return hash;
  }
  
}


abstract class HasIsarId  {
  late Id id;

  HasIsarId() {
    id = getId();
  }

  @ignore
  List<Object> get primaryKeyObjects;

  int getId() {
    String stringId = "";
    for(Object obj in primaryKeyObjects) {
      stringId += obj.toString();
    }
    return stringId.fastHash();
  }

}

abstract class MapsTo<T> {
  T toEntity();
}
