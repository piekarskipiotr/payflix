import 'package:payflix/common/constants.dart';

enum GroupType {
  netflix,
  hboMax,
  primeVideo,
  disneyPlus,
  hulu
}

extension GroupTypeExtension on GroupType {
  String get vodName {
    switch(this) {
      case GroupType.netflix:
        return 'Netflix';
      case GroupType.hboMax:
        return 'HBO Max';
      case GroupType.primeVideo:
        return 'Prime Vid.';
      case GroupType.disneyPlus:
        return 'Disney+';
      case GroupType.hulu:
        return 'Hulu';
    }
  }

  String get codeName {
    switch(this) {
      case GroupType.netflix:
        return 'nflix';
      case GroupType.hboMax:
        return 'homax';
      case GroupType.primeVideo:
        return 'pvide';
      case GroupType.disneyPlus:
        return 'dplus';
      case GroupType.hulu:
        return 'hflix';
    }
  }

  String get logo {
    switch(this) {
      case GroupType.netflix:
        return netflixLogo;
      case GroupType.hboMax:
        return hboLogo;
      case GroupType.primeVideo:
        return primeLogo;
      case GroupType.disneyPlus:
        return disneyLogo;
      case GroupType.hulu:
        return huluLogo;
    }
  }
}

class GroupTypeHelper {
  static getGroupTypeByCode(String code) {
    switch(code) {
      case 'nflix':
        return GroupType.netflix;
      case 'homax':
        return GroupType.hboMax;
      case 'pvide':
        return GroupType.primeVideo;
      case 'dplus':
        return GroupType.disneyPlus;
      case 'hflix':
        return GroupType.hulu;
    }
  }

  static getCodeByGroupType(GroupType groupType) {
    switch(groupType) {
      case GroupType.netflix:
        return 'nflix';
      case GroupType.hboMax:
        return 'homax';
      case GroupType.primeVideo:
        return 'pvide';
      case GroupType.disneyPlus:
        return 'dplus';
      case GroupType.hulu:
        return 'hflix';
    }
  }

  static GroupType getGroupTypeFromGroupId(String groupId) {
    var length = groupId.length;
    var code = groupId.substring(length - 5, length);
    return getGroupTypeByCode(code);
  }
}