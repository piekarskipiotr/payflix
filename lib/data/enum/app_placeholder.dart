import 'package:payflix/common/constants.dart';

enum AppPlaceholder {
  avatar,
  vod
}

extension AppPlaceholderExtension on AppPlaceholder {
  String get image {
    switch(this) {
      case AppPlaceholder.avatar: return avatarPlaceholder;
      case AppPlaceholder.vod: return vodPlaceholder;
    }
  }
}