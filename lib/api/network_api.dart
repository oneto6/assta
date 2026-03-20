import 'dart:convert';
import 'dart:math';

import 'package:assta/extension/common.dart';
import 'package:assta/model/prompt.dart';
import 'package:assta/model/session.dart';
import 'package:assta/model/suggestion.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

Future<String?> dummySession() async {
  final content = await rootBundle.loadString('asset/dummy_prompt.json');
  final Map decode;
  try {
    decode = jsonDecode(content);
  } catch (_) {
    return null;
  }
  final list = decode['data'];
  if (list is! List) return null;
  final res = [];
  for (var i in list) {
    res.add({'id': i['id'], 'name': i['name']});
  }
  return jsonEncode({"success": true, "data": res});
}

Future<String?> dummyChatID() async {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random();
  final id = List.generate(
    16,
    (_) => chars[random.nextInt(chars.length)],
  ).join();
  final sessionID = 'session_$id';
  return sessionID;
}

Future<String?> dummyPromt(String id) async {
  final content = await rootBundle.loadString('asset/dummy_prompt.json');
  final Map decode;
  try {
    decode = jsonDecode(content);
  } catch (_) {
    return null;
  }
  final list = decode['data'];
  if (list is! List) return "";
  for (var i in list) {
    if (i['id'] != id) continue;
    return jsonEncode({"success": true, "data": i['chat']});
  }
  return jsonEncode({"success": true, "data": []});
}

Future<String> dummySuggestion(int page, int limit) async {
  final content = await rootBundle.loadString('asset/dummy_suggestion.json');

  final Map<String, dynamic> jsonData = jsonDecode(content);
  final List<dynamic> allItems = jsonData['data'] ?? [];

  final int currentPage = page < 1 ? 1 : page;

  final int start = (currentPage - 1) * limit;
  final int end = (start + limit) > allItems.length
      ? allItems.length
      : start + limit;

  final List<dynamic> paginatedItems = (start < allItems.length)
      ? allItems.sublist(start, end)
      : [];

  return jsonEncode({"status": "success", "data": paginatedItems});
}

sealed class ApiState<T> {}

class ApiStateData<T> extends ApiState<T> {
  final T data;
  ApiStateData(this.data);
}

class ApiStateError<T> extends ApiState<T> {
  String? message;
  ApiStateError({this.message});
}

class NetworkApi {
  static const baseUrl = "www.awsome.com/";
  static NetworkApi? _instance;

  static NetworkApi get instance {
    final inst = _instance;
    if (inst == null) {
      throw Exception("_instance == null");
    }
    return inst;
  }

  final String auth;

  NetworkApi._internal(this.auth);

  Future<ApiState<String>> chatCreate() async {
    final error = ApiStateError<String>();
    Response res;

    try {
      res = await get(Uri.https(baseUrl, '/chat_create'));
    } catch (_) {
      await Future.delayed(Duration(seconds: 1));
      final id = await dummyChatID();
      final body = jsonEncode({
        "success": true,
        "data": {"sessionID": id},
      });

      res = Response(body, 200);
      // throw error;
    }

    final dynamic decoded;
    try {
      decoded = jsonDecode(res.body);
    } catch (_) {
      throw error;
    }

    if (decoded is! Map || decoded['success'] != true) return error;

    final data = decoded['data'];
    if (data is! Map) return error;

    final id = data['sessionID'];
    if (id is! String) return error;

    return ApiStateData("session_new");
    // return ApiStateData(id);
  }

  Future<ApiState<List<Session>>> session() async {
    final error = ApiStateError<List<Session>>();
    Response res;
    try {
      res = await get(Uri.https(baseUrl, '/session'));
    } catch (_) {
      final dummy = await dummySession();
      if (dummy == null) throw Exception("dummy == null");
      res = Response(dummy, 200);
      // throw error;
    }
    final dynamic body;
    try {
      body = jsonDecode(res.body);
    } catch (e) {
      throw error;
    }
    if (body is! Map || body['success'] != true) {
      return error;
    }
    final data = body['data'];
    if (data is! List) return error;
    final list = <Session>[];
    for (var i in data) {
      try {
        list.add(Session.fromMap(i));
      } catch (e) {
        continue;
      }
    }
    return ApiStateData(list);
  }

  Future<ApiState<List<Prompt>>> getChat({required String id}) async {
    final error = ApiStateError<List<Prompt>>();
    Response res;
    try {
      res = await get(Uri.https(baseUrl, '/chat', {"id": id}));
    } catch (_) {
      final dummy = await dummyPromt(id);
      if (dummy == null) throw Exception("dummy == null");
      res = Response(dummy, 200);
      // throw error;
    }
    final dynamic body;
    try {
      body = jsonDecode(res.body);
    } catch (_) {
      throw error;
    }
    if (body is! Map || body['success'] != true) return error;
    final data = body['data'];
    if (data is! List) return error;
    final list = <Prompt>[];
    for (var i in data) {
      try {
        list.add(Prompt.fromMap(i));
      } catch (e) {
        continue;
      }
    }
    return ApiStateData(list);
  }

  Future<ApiState<List<Suggestion>>> suggestion(int page, int limit) async {
    Response res;
    try {
      res = await get(
        Uri.https(baseUrl, '/suggestions', {'page': page, 'limit': limit}),
      );
    } catch (_) {
      final body = await dummySuggestion(page, limit);
      res = Response(body, 200);
      // return ApiStateError();
    }
    if (!res.success) {
      return ApiStateError();
    }
    final data = jsonDecode(res.body)?["data"];
    if (data is! List) {
      return ApiStateError();
    }
    final List<Suggestion> list = [];
    for (var item in data) {
      final Suggestion s;
      try {
        s = Suggestion.fromMap(item);
      } catch (e) {
        // print(e);
        continue;
      }
      list.add(s);
    }
    return ApiStateData(list);
  }

  static void init(String auth) {
    _instance = NetworkApi._internal(auth);
  }

  Future<ApiState<Prompt>> chatSend({
    required String session,
    required String message,
  }) async {
    final error = ApiStateError<Prompt>();
    final encode = jsonEncode({"sessionID": session, "message": message});
    Response res;
    try {
      res = await post(Uri.https(baseUrl, "/chat/$session"), body: encode);
    } catch (_) {
      final body = {
        'success': true,
        'data': {
          'id': Random().nextInt(100),
          'type': 0,
          'message':
              "Hi! I can help to some extent. A good approach is to break things down, start simple, and refine as needed. Let me know what you'd like help with.",
        },
      };
      res = Response(jsonEncode(body), 200);
      await Future.delayed(Duration(seconds: 3));
      // rethrow;
    }
    if (res.success == false) throw error;
    final body = jsonDecode(res.body);
    if (body is! Map || body['success'] == false) throw error;
    final Prompt prompt;
    try {
      prompt = Prompt.fromMap(body['data']);
    } catch (e) {
      return error;
    }
    return ApiStateData(prompt);
  }
}
