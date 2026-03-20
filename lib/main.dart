import 'package:assta/api/network_api.dart';
import 'package:assta/provider/go_router.dart';
import 'package:assta/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    NetworkApi.init("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final routerConfig = ref.watch(routerConfigProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: routerConfig,
      title: 'Flutter Demo',

      // theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.black)),
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
    );
  }
}
