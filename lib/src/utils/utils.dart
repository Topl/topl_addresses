import 'package:collection/collection.dart';

/// Returns whether [list1] and [list2] have the same contents.
bool listEquals(List<Object?>? list1, List<Object?>? list2) =>
    const ListEquality<Object?>().equals(list1, list2);
