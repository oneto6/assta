import 'dart:async';

import 'package:assta/api/network_api.dart';
import 'package:assta/model/session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sessionProvider = AsyncNotifierProvider(SessionNotifier.new);

class SessionNotifier extends AsyncNotifier<List<Session>> {
  @override
  FutureOr<List<Session>> build() async {
    final res = await NetworkApi.instance.session();
    print("res: $res");
    if (res is! ApiStateData<List<Session>>) {
      throw Exception("res is! ApiStateData<List<Session>>");
    }
    return res.data;
  }
}
