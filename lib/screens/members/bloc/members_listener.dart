import 'package:flutter/material.dart';
import 'package:payflix/screens/members/bloc/members_state.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MembersListener {
  static listenToState(
    BuildContext context,
    MembersState state,
    RefreshController controller,
  ) {
    if (state is FetchingMembersSucceeded) {
      if (controller.isRefresh) {
        controller.refreshCompleted();
      }
    } else if (state is FetchingMembersFailed) {
      if (controller.isRefresh) {
        controller.refreshFailed();
      }
    }
  }
}
