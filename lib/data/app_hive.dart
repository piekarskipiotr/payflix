import 'package:hive_flutter/hive_flutter.dart';
import 'package:payflix/common/constants.dart';

import 'model/invite_info.dart';

// global boxes
late Box invitesBox;

class AppHive {
  
  Future initHive() async {
    await Hive.initFlutter();
    await _initAdapters();
    await _initBoxes();
  }
  
  Future _initBoxes() async {
    invitesBox = await Hive.openBox(invitesBoxKey).then((value) {
      // clear dynamic link on app re-launch
      value.put(dynamicLinkKey, null);
      return value;
    });
  }

  Future _initAdapters() async {
    Hive.registerAdapter(InviteInfoAdapter());
  }
}

// Currently the app doesn't use any of this boxes, so if nothing changes
// this file and whole Hive module should be removed before the app release