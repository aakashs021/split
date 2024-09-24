import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:split/model/user_model.dart';

class SearchListGetx extends GetxController {
  TextEditingController controller = TextEditingController();

  List<UserModel> filterlist = [];

  Timer? _debounce;

  List<UserModel> orderedlist = [];
  ifFreind({required List friends}) {
    for (int i = 0; i < filterlist.length; i++) {
      if (friends.contains(filterlist[i].email)) {
        filterlist[i].friend = null;
      }
    }
  }

  onCircleAvatartap({
    required int index,
  }) {
    if (filterlist[index].friend == null) {
      return;
    }
    filterlist[index].friend = !filterlist[index].friend!;
    update(); // Update the UI
  }

  oninit({required List<UserModel>? searchlist}) {
    if (searchlist == null) {
      return;
    }
    filterlist = searchlist;
    filterlist
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    orderedlist = filterlist;
  }

  onDebounce(VoidCallback action, {int milliseconds = 300}) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: milliseconds), action);
  }

  void onSearchChanged(String query) {
  onDebounce(() {
    if (query.isEmpty) {
      // Restore the original ordered list if the query is empty
      filterlist = List.from(orderedlist);
    } else {
      // Filter the list based on the query without resetting the friend status
      filterlist = orderedlist
          .where(
              (user) => user.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    update();
  });
}

}



