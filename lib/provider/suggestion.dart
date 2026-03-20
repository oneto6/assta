import 'dart:async';

import 'package:assta/api/network_api.dart';
import 'package:assta/model/suggestion.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final suggestionProvider = AsyncNotifierProvider(SuggestionaNotifier.new);

class SuggestionaNotifier extends AsyncNotifier<List<Suggestion>> {
  var page = 0;
  static const limit = 10;

  @override
  FutureOr<List<Suggestion>> build() async {
    page = 1;
    final s = await NetworkApi.instance.suggestion(0, limit);
    switch (s) {
      case ApiStateData<List<Suggestion>>(data: final data):
        return data;
      case ApiStateError<List<Suggestion>>():
        throw Exception("Network Issue");
    }
  }

  Future<int> loadMore() async {
    final stateValue = state.value;
    if (stateValue == null) return 1;
    final delay = Future.delayed(Duration(seconds: 4));
    page += 1;
    final s = await NetworkApi.instance.suggestion(page, limit);
    await delay;
    if (s is! ApiStateData<List<Suggestion>> || s.data.isEmpty) return 1;
    state = AsyncData([...stateValue, ...s.data]);
    return 0;
  }

  Future<void> refresh() async {
    final delay = Future.delayed(Duration(seconds: 4));
    page += 1;
    final s = await NetworkApi.instance.suggestion(page, limit);
    await delay;
    if (s is! ApiStateData<List<Suggestion>> || s.data.isEmpty) return;
    state = AsyncData([...s.data]);
  }
}
