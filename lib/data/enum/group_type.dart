enum GroupType {
  netflix,
}

extension GroupTypeExtension on GroupType {
  String get codeName {
    switch(this) {
      case GroupType.netflix:
        return 'nflix';
    }
  }
}