import 'dart:async';
import 'dart:math';
import 'package:assta/api/network_api.dart';
import 'package:assta/model/prompt.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final promptProvider = AsyncNotifierProvider.family.autoDispose(
  PromptNotifier.new,
);

class PromptNotifier extends AsyncNotifier<List<Prompt>> {
  final String id;
  PromptNotifier(this.id);

  @override
  FutureOr<List<Prompt>> build() async {
    final delay = Future.delayed(Duration(seconds: 3));
    final ApiState<List<Prompt>> res;
    try {
      res = await NetworkApi.instance.getChat(id: id);
    } catch (e) {
      // print(e);
      rethrow;
    }
    if (res is! ApiStateData<List<Prompt>>) {
      throw Exception("res is! ApiStateData<List<Prompt>>");
    }
    await delay;
    return res.data;
  }

  Future<void> send(String text) async {
    await future;
    List<Prompt> current = state.value ?? <Prompt>[];
    final Future<ApiState<Prompt>> post;
    try {
      post = NetworkApi.instance.chatSend(session: id, message: text);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return; // skip for the demo to work
    }
    state = AsyncData([
      ...current,
      Client(id: Random().nextInt(100).toString(), message: text),
    ]);
    final res = await post;
    if (res is! ApiStateData<Prompt>) return;
    current = state.value ?? [];
    state = AsyncData([...current, res.data]);
  }
}
